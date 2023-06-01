
Main()
{
    blanco\waypoints\binary_heap_tests::Main();
    blanco\waypoints\chunks_tests::Main();
    blanco\waypoints\edges_tests::Main();
    blanco\tests::RunAll();

    level.discovery_range = 50;
    level.DRAW_WAYPOINT_DISTNACE_SQUARED = 160 * 160;
    level.DRAW_EDGE_DISTNACE_SQUARED = 1000 * 1000;
    level.DISCOVER_OFFSET = 30;
    level.DISCOVERY_DEFAULT_MAX_ITERATIONS = 5000;

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
            setCvar("start", "");
            args = StrTok(start, " ");

            maxIterationsCount = int(args[0]);
            if (maxIterationsCount == 0)
                maxIterationsCount = level.DISCOVERY_DEFAULT_MAX_ITERATIONS;

            startDiscovery(maxIterationsCount);
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

startDiscovery(maxIterationsCount)
{
    resetGraph();

    startOrigin = getStartingOrigin();
    index = addNode(startOrigin);
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

        if (isOriginAlreadyInNodes(newOrigin))
        {
            if (isDebug)
                addPrint(newOrigin, "Already", (0.2, 0.6, 0.99));

            continue;
        }

        if (isDebug)
            addPrint(newOrigin, "New", (0.2, 0.6, 0.99));

        index = addNode(newOrigin);
        checkAndAddEdge(nodeIndex, index);
        checkAndAddEdge(index, nodeIndex);
        checkEdges(index);
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

checkEdges(newNode)
{
    neighbours = buildNeighboursToCheck([], newNode, 1);

    for (i = 0; i < neighbours.size; i += 1)
    {
        neighbour = neighbours[i];
        if (neighbour == newNode)
            continue;

        checkAndAddEdge(neighbour, newNode);
        checkAndAddEdge(newNode, neighbour);
    }
}

buildNeighboursToCheck(neighbours, index, iteration)
{
    if (iteration > 3)
        return neighbours;

    edges = getEdgesFrom(index);
    // printArray(edges, "edges of " + index, ::printEdge);
    for (i = 0; i < edges.size; i += 1)
        if (!isInArray(neighbours, edges[i].to))
        {
            neighbours[neighbours.size] = edges[i].to;
            neighbours = buildNeighboursToCheck(neighbours, edges[i].to, iteration + 1);
        }

    return neighbours;
}

checkAndAddEdge(from, to)
{
    if (edgeExists(from, to))
        return;

    dist = distanceSquared(getNode(from).origin, getNode(to).origin);
    if (dist > level.discovery_range * level.discovery_range * 2.01)
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

playerLoop()
{
    while (isDefined(self))
    {
        self drawNodesAndEdges();

        if (self useButtonPressed())
        {
            origin = self getTargetOrigin();
            nodeIndex = getClosestNodeIndex(origin);
            
            edges = getEdgesFrom(nodeIndex);
            printArray(edges, "edges of " + nodeIndex, ::printEdge);

            while (self useButtonPressed())
                wait 0.05;
        }

        if (self meleeButtonPressed())
        {
            origin = self getTargetOrigin();
            nodeIndex = getClosestNodeIndex(origin);
            clearPrintsAndLines();
            discoverFromNode(nodeIndex, true);
            level.p.debugNode = nodeIndex;

            while (self meleeButtonPressed())
                wait 0.05;
        }

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

        if (dist > level.DRAW_EDGE_DISTNACE_SQUARED)
            continue;

        edges = getEdgesFrom(i);
        if (!isDefined(edges))
            continue;

        for (j = 0; j < edges.size; j += 1)
        {
            isTwoWay = isTwoWayEdge(i, edges[j].to);
            if (isTwoWay && edges[j].to > i) // This was already printed from other node
                continue;

            endNode = getNode(edges[j].to);
            color = (0.9, 0.7, 0.6);
            if (!isTwoWay)
                color = (0.2, 0.6, 0.99);

            line(node.origin, endNode.origin, color, false, 1);
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
    if (!isDefined(level.p.lines))
        level.p.lines = [];

    aLine = spawnStruct();
    aLine.start = start;
    aLine.end = end;
    aLine.color = color;

    n = level.p.lines.size;
    level.p.lines[n] = aLine;
}

addPrint(origin, text, color)
{
    if (!isDefined(level.p.prints))
        level.p.prints = [];

    aPrint = spawnStruct();
    aPrint.origin = origin;
    aPrint.text = text;
    aPrint.color = color;

    n = level.p.prints.size;
    level.p.prints[n] = aPrint;
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

getClosestNodeIndex(origin)
{
    closest = 0;
    closestDist = distanceSquared(level.nodes[0].origin, origin);

    for (i = 1; i < level.nodes.size; i += 1)
    {
        dist = distanceSquared(level.nodes[i].origin, origin);
        if (dist < closestDist)
        {
            closest = i;
            closestDist = dist;
        }
    }

    return closest;
}

getNode(index)
{
    return level.nodes[index];
}

edgeExists(from, to)
{
    if (!isDefined(level.edges[from + ""]))
        return false;

    edges = level.edges[from + ""];
    for (i = 0; i < edges.size; i += 1)
        if (edges[i].to == to)
            return true;

    return false;
}

isTwoWayEdge(from, to)
{
    return edgeExists(from, to) && edgeExists(to, from);
}

addEdge(from, to)
{
    if (!isDefined(level.edges[from + ""]))
        level.edges[from + ""] = [];

    dist = distance(getNode(from).origin, getNode(to).origin);
    
    edge = spawnStruct();
    edge.to = to;
    edge.weight = dist;

    level.edges[from + ""][level.edges[from + ""].size] = edge;
}

getEdgesFrom(from)
{
    if (!isDefined(level.edges[from + ""]))
        return [];

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



printArray(array, name, printItemFunction)
{
    if (array.size == 0)
    {
        iPrintLn(name + "(0) = [empty]");
        return;
    }

    if (!isDefined(printItemFunction))
        printItemFunction = ::printDefault;

    message = name + "(" + array.size + ") = [";
    for (i = 0; i < array.size; i += 1)
        message += [[printItemFunction]](array[i]) + ", ";

    message = GetSubStr(message, 0, message.size - 2) + "]";
    iPrintln(message);
}

printDefault(item)
{
    return item;
}

printEdge(item)
{
    return "(to=" + item.to + ", w=" + item.weight + ")";
}

getTargetOrigin()
{
    startOrigin = self.origin + (0, 0, 60);
    forward = anglesToForward(self getplayerangles());
    forward = maps\mp\_utility::vectorScale(forward, 100000);
    endOrigin = startOrigin + forward;
    trace = bulletTrace(startOrigin, endOrigin, false, self);

    if (trace["fraction"] <= 1 || trace["surfacetype"] == "default")
        endOrigin = trace["position"];

    return endOrigin;
}