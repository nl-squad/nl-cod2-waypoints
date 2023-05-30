
Main()
{
    level.discovery_range = 50;
    level.DRAW_WAYPOINT_DISTNACE_SQUARED = 160 * 160;
    level.DISCOVER_OFFSET = 30;

    resetGraph();
    startDiscovery();

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

controlCvars()
{
    setCvar("start", "");

    while(true)
    {
        start = getCvar("start");
        if (start != "")
        {
            startDiscovery();
            setCvar("start", "");
        }

        wait 0.1;
    }
}

initalizePlayer()
{
    while (true)
    {
		level waittill("connecting", player);
        player thread playerLoop();
    }
}

startDiscovery()
{
    resetGraph();
    startingSpawnPoint = getStartingSpawnPoint();
    index = addNode(startingSpawnPoint.origin);
    addToOpenSet(index);

    maxIterations = 100000;
    currentIteration = 1;
    discoverNodeIndex = getNextNodeIndexFromOpenSet();
    while (isDefined(discoverNodeIndex))
    {
        discoverFromNode(discoverNodeIndex);

        if (currentIteration == maxIterations)
        {
            iPrintln("Ending on iteration " + currentIteration);
            break;
        }

        currentIteration += 1;
        discoverNodeIndex = getNextNodeIndexFromOpenSet();
    }

    iPrintln("Discovered nodes: " + level.nodes.size);
	players = getEntArray("player", "classname");
    for (i = 0; i < players.size; i += 1)
    {
        if (!isAlive(players[i]))
            continue;

        players[i] setOrigin(startingSpawnPoint.origin);
    }
}

discoverFromNode(nodeIndex)
{
    node = getNode(nodeIndex);

    directions = getPossibleNormalizedDirections();
    for (i = 0; i < directions.size; i += 1)
    {
        direction = directions[i];
        newOrigin = getNewOrigin(node.origin, direction);

        if (!isDefined(newOrigin))
            continue;

        if (isOriginAlreadyInNodes(newOrigin))
            continue;

        if (!isOriginAccesibleFromOther(node.origin, newOrigin))
            continue;

        index = addNode(newOrigin);
        addEdge(nodeIndex, index);
        addToOpenSet(index);
    }
}

getNewOrigin(origin, direction)
{
    origin = origin + (0, 0, level.DISCOVER_OFFSET);
    origin = getDirectionOrigin(origin, direction);
    if (!isDefined(origin))
        return undefined;

    origin = putOnTheGround(origin);
    return origin;
}

playerLoop()
{
    while (isDefined(self))
    {
        self drawNodesAndEdges();
        wait 0.05;
    }
}

drawNodesAndEdges()
{
    for (i = 0; i < level.nodes.size; i += 1)
    {
        node = level.nodes[i];
        dist = distanceSquared(self.origin, node.origin);
        if (dist < level.DRAW_WAYPOINT_DISTNACE_SQUARED)
            print3d(node.origin + (0, 0, 2), i, (1, 1, 1), 1, 0.3, 1);

        edges = getEdgesFrom(i);
        if (!isDefined(edges))
            continue;

        for (j = 0; j < edges.size; j += 1)
        {
            start = node.origin + (0, 0, 1);
            endNode = getNode(edges[j].to);
            end = endNode.origin + (0, 0, 1);
            line(start, end, (0.9, 0.7, 0.6), false, 1);
        }
    }
}

getStartingSpawnPoint()
{
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

getDirectionOrigin(origin, direction)
{
    directionOrigin = origin + maps\mp\_utility::vectorScale(direction, level.discovery_range);

    trace = bulletTrace(origin, directionOrigin, false, undefined);
    if (trace["fraction"] == 1)
        return directionOrigin;

    adjustedDirection = vectorNormalize(trace["position"] - origin);
    slopeAdjustedOrigin = origin + maps\mp\_utility::vectorScale(adjustedDirection, level.discovery_range);
    adjustedTrace = bulletTrace(origin, slopeAdjustedOrigin, false, undefined);

    if (adjustedTrace["fraction"] == 1)
        return slopeAdjustedOrigin;

    dist = distance(adjustedTrace["position"], origin);
    justBeforeWallOrigin = origin + maps\mp\_utility::vectorScale(adjustedDirection, dist - 1);
    return justBeforeWallOrigin;
}

putOnTheGround(origin)
{
    trace = bulletTrace(origin + (0, 0, 1), origin - (0, 0, 100), false, undefined);
    if (trace["fraction"] < 1)
        return trace["position"];

    return undefined;
}

isOriginAlreadyInNodes(origin)
{
    for (i = 0; i < level.nodes.size; i += 1)
    {
        dist = distanceSquared(origin, level.nodes[i].origin);
        if (dist < level.discovery_range * level.discovery_range / 4)
            return true;
    }

    return false;
}

isOriginAccesibleFromOther(fromOrigin, toOrigin)
{
    trace = bulletTrace(fromOrigin + (0, 0, 14), toOrigin + (0, 0, 14), false, undefined);
    iPrintln(trace["fraction"]);
    if (trace["fraction"] == 1)
        return true;

    return false;
}

addNode(origin)
{
    node = spawnStruct();
    node.origin = origin;

    n = level.nodes.size;
    level.nodes[n] = node;

    return n;
}

getNode(index)
{
    return level.nodes[index];
}

addEdge(from, to)
{
    if (!isDefined(level.edges[from + ""]))
        level.edges[from + ""] = [];
    
    edge = spawnStruct();
    edge.to = to;
    edge.weight = distance(getNode(from).origin, getNode(to).origin);

    level.edges[from + ""][level.edges[from + ""].size] = edge;
}

getEdgesFrom(from)
{
    return level.edges[from + ""];
}

addToOpenSet(index)
{
    level.openSet[level.openSet.size] = index;
}

getNextNodeIndexFromOpenSet()
{
    index = level.openSetNextIndex;
    level.openSetNextIndex += 1;

    if (index >= level.openSet.size)
        return undefined;

    return level.openSet[index];
}
