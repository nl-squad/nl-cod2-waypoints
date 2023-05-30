
Main()
{
    level.discovery_range = 50;
    level.DRAW_WAYPOINT_DISTNACE_SQUARED = 160 * 160;
    level.DISCOVER_OFFSET = 30;
    level.discoverNodesMaxIterations = 100000;

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

controlCvars()
{
    setCvar("start", "");
    setCvar("debugNode", "");

    while(true)
    {
        start = getCvar("start");
        if (start != "")
        {
            startDiscovery();
            setCvar("start", "");
        }

        debugNode = getCvar("debugNode");
        if (debugNode != "")
        {
            clearPrintsAndLines();
            discoverFromNode(int(debugNode), true);
            setCvar("debugNode", "");
        }

        wait 0.1;
    }
}

initalizePlayer()
{
    level waittill("connecting", player);
    level.p = player;
    level.p thread playerLoop();
}

startDiscovery()
{
    iPrintln("startDiscovery");
    print("startDiscovery");
    startTime = getTime();
    resetGraph();
    startingSpawnPoint = getStartingSpawnPoint();
    index = addNode(startingSpawnPoint.origin);
    addToOpenSet(index);

    discoverNodes();
    iPrintln("Discovered nodes: ^2" + level.nodes.size);
    iPrintln("Iterations: ^2" +  level.discoverNodesIterations);

    discoverEdges();

    secondsPassed = (getTime() - startTime) / 1000;
    iPrintln("Discovery took: ^2" + secondsPassed "s")
}

discoverNodes()
{
    level.discoverNodesIterations = 1;
    discoverNodeIndex = getNextNodeIndexFromOpenSet();
    while (isDefined(discoverNodeIndex))
    {
        discoverFromNode(discoverNodeIndex, false);

        if (level.discoverNodesIterations == level.discoverNodesMaxIterations)
            break;

        level.discoverNodesIterations += 1;
        discoverNodeIndex = getNextNodeIndexFromOpenSet();
    }

    return level.discoverNodesIterations;
}

discoverEdges()
{
    for (i = 0; i < level.nodes.size; i += 1)
    {
        node = level.nodes[i];

        for (j = 0; j < level.nodes.size; j += 1)
        {
            if (i == j)
                continue;

            otherNode = level.nodes[j];

            dist = distanceSquared(node.origin, otherNode.origin);
            if (dist > level.discovery_range * level.discovery_range * 2.25)
                continue;

            if (!isOriginAccesibleFromOther(node.origin, otherNode.origin))
                continue;

            addEdge(i, j);
        }


        if (i % 10 == 0)
        {
            iPrintln("Processed nodes: ^5" + int(100 * i / level.nodes.size) + "%");
            print("Processed nodes: ^5" + int(100 * i / level.nodes.size) + "%");
        }
    }
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

        if (isOriginAlreadyInNodes(newOrigin))
        {
            if (isDebug)
                addPrint(newOrigin, "Already", (0.2, 0.6, 0.99));

            continue;
        }

        if (!isDebug)
        {
            index = addNode(newOrigin);
            addToOpenSet(index);
        }
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

    if (isDefined(level.p.lines))
    {
        for (i = 0; i < level.p.lines.size; i += 1)
        {
            aLine = level.p.lines[i];
            line(aLine.start, aLine.end, aLine.color, false, 1);
        }
    }

    if (isDefined(level.p.prints))
    {
        for (i = 0; i < level.p.prints.size; i += 1)
        {
            aPrint = level.p.prints[i];
            print3d(aPrint.origin, aPrint.text, aPrint.color, 1, 0.3, 1);
        }
    }
}

clearPrintsAndLines()
{
    level.p.lines = [];
    level.p.prints = [];
}

addLine(start, end, color)
{
    aLine = spawnStruct();
    aLine.start = start;
    aLine.end = end;
    aLine.color = color;

    n = level.p.lines.size;
    level.p.lines[n] = aLine;
}

addPrint(origin, text, color)
{
    aPrint = spawnStruct();
    aPrint.origin = origin;
    aPrint.text = text;
    aPrint.color = color;

    n = level.p.prints.size;
    level.p.prints[n] = aLine;
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
        addLine(origin, slopeAdjustedOrigin, (0, 0.6, 1));

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
