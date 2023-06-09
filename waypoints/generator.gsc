Main()
{
    level.GRID_SIZE = 50;
    level.EDGE_STAND = 1;
    level.EDGE_CROUCH = 2;
    level.EDGE_PRONE = 3;
    level.EDGE_JUMP = 4;
    level.EDGE_LADDER = 4;

    level.discovery_range = 50;
    level.DISCOVER_OFFSET = 33;
    level.DISCOVER_PRONE_MIN_HEIGHT = 32;
    level.DISCOVERY_DEFAULT_MAX_ITERATIONS = 5000;
    level.MINIMUM_SPACE_BETWEEN_NODES_SQUARED = level.discovery_range * level.discovery_range / 2;

    resetGraph();

    setCvar("developer", "2");
    setCvar("developer_script", "1");

    thread controlCvars();
    thread initalizePlayer();
}



resetGraph()
{
    level.nodes = [];
    level.edges = [];
    level.openSet = [];
    level.openSetNextIndex = 0;
}

startDiscovery(maxIterationsCount)
{
    resetGraph();

    startOrigin = getStartingOrigin();
    index = addNode(startOrigin, -1);
    addToOpenSet(index);

    discoverNodes(maxIterationsCount);
    iPrintln("Discovered nodes: ^2" + level.nodes.size);
    iPrintln("Iterations: ^2" +  level.discoverNodesIterations);
}

discoverNodes(maxIterationsCount)
{
    level.discoverNodesIterations = 1;
    discoverNodeIndex = getNextNodeIndexFromOpenSet();
    while (isDefined(discoverNodeIndex))
    {
        discoverFromNode(discoverNodeIndex, false);

        if (level.discoverNodesIterations == maxIterationsCount)
            break;

        level.discoverNodesIterations += 1;
        discoverNodeIndex = getNextNodeIndexFromOpenSet();

        if (level.discoverNodesIterations % 100 == 0)
        {
            iPrintln("Done: ^2" + int(level.discoverNodesIterations * 100 / maxIterationsCount) + "%");
            wait 0.1;
        }
    }

    return level.discoverNodesIterations;
}

discoverFromNode(nodeIndex, isDebug)
{
    node = getNode(nodeIndex);

    directions = getPossibleNormalizedDirections();
    for (i = 0; i < directions.size; i += 1)
    {
        direction = directions[i];
        newOrigin = getNewOrigin(node.origin, direction, isDebug);

        if (!isDefined(newOrigin))
            continue;

        existingIndex = getOriginNodeIndex(newOrigin);
        if (isDefined(existingIndex))
        {
            checkAndAddEdge(nodeIndex, existingIndex);
            checkAndAddEdge(existingIndex, nodeIndex);

            if (isDebug)
                addPrint(newOrigin, "Already", (0.2, 0.6, 0.99));

            continue;
        }

        if (isDebug)
            addPrint(newOrigin, "New", (0.2, 0.6, 0.99));

        index = addNode(newOrigin, nodeIndex);
        checkAndAddEdge(nodeIndex, index);
        checkAndAddEdge(index, nodeIndex);
        // checkEdges(index);
        addToOpenSet(index);
    }
}

getNewOrigin(origin, direction, isDebug)
{
    origin = origin + (0, 0, level.DISCOVER_OFFSET);
    origin = getDirectionOrigin(origin, direction, isDebug);
    if (!isDefined(origin))
        return undefined;

    onGroundOrigin = putOnTheGround(origin);

    if (isDebug)
    {
        if (isDefined(onGroundOrigin))
            addLine(origin, onGroundOrigin, (0, 1, 0));
        else
            addLine(origin, origin - (0, 0, 100), (1, 0, 0));
    }

    return onGroundOrigin;
}

checkAndAddEdge(from, to)
{
    if (edgeExists(from, to))
        return;
    
    start = getNode(from).origin + (0, 0, level.DISCOVER_PRONE_MIN_HEIGHT);
    end = getNode(to).origin + (0, 0, level.DISCOVER_PRONE_MIN_HEIGHT);

    dist = distanceSquared(start, end);
    if (dist > level.discovery_range * level.discovery_range * 1.5 * 1.5)
        return;

    trace = bulletTrace(start, end, false, undefined);
    if (trace["fraction"] < 1)
        return;

    addEdge(from, to);
}

isInArray(array, item)
{
    for (i = 0; i < array.size; i += 1)
        if (array[i] == item)
            return true;

    return false;
}

getStartingOrigin()
{
    if (isDefined(level.p))
        return level.p.origin;

	spawnpointname = "mp_tdm_spawn";
	spawnpoints = getEntArray(spawnpointname, "classname");
    return spawnpoints[ randomInt(spawnpoints.size) ];
}

getPossibleNormalizedDirections()
{
    directions = [];
    directions[directions.size] = (1, 0, 0);
    directions[directions.size] = (-1, 0, 0);
    directions[directions.size] = (0, 1, 0);
    directions[directions.size] = (0, -1, 0);

    return directions;
}

getDirectionOrigin(origin, direction, isDebug)
{
    directionOrigin = origin + maps\mp\_utility::vectorScale(direction, level.discovery_range);

    trace = bulletTrace(origin, directionOrigin, false, undefined);
    if (trace["fraction"] == 1)
    {
        if (isDebug)
            addLine(origin, directionOrigin, (0, 1, 0));

        return directionOrigin;
    }

    adjustedDirection = vectorNormalize(trace["position"] - origin);
    slopeAdjustedOrigin = origin + maps\mp\_utility::vectorScale(adjustedDirection, level.discovery_range);
    adjustedTrace = bulletTrace(origin, slopeAdjustedOrigin, false, undefined);

    if (adjustedTrace["fraction"] == 1)
    {
        if (isDebug)
            addLine(origin, slopeAdjustedOrigin, (0, 0, 1));

        return slopeAdjustedOrigin;
    }

    dist = distance(adjustedTrace["position"], origin);
    justBeforeWallOrigin = origin + maps\mp\_utility::vectorScale(adjustedDirection, dist - 1);

    if (isDebug)
        addLine(origin, justBeforeWallOrigin, (0, 0.6, 1));

    return justBeforeWallOrigin;
}

putOnTheGround(origin)
{
    trace = bulletTrace(origin + (0, 0, 1), origin - (0, 0, 100), false, undefined);
    if (trace["fraction"] < 1)
        return trace["position"];

    return undefined;
}

getOriginNodeIndex(origin)
{
    for (i = 0; i < level.nodes.size; i += 1)
    {
        dist = distanceSquared(origin, level.nodes[i].origin);
        if (dist <= level.MINIMUM_SPACE_BETWEEN_NODES_SQUARED)
            return i;
    }

    return undefined;
}

