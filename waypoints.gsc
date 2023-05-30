
Main()
{
    level.discovery_range = 40;

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

    maxIterations = 10000;
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
        newOrigin = node.origin + maps\mp\_utility::vectorScale(direction, level.discovery_range);

        if (isOriginAlreadyInNodes(newOrigin))
            continue;

        if (!isOriginAccesibleFromOther(node.origin, newOrigin))
            continue;

        index = addNode(newOrigin);
        addEdge(nodeIndex, index);
        addToOpenSet(index);
    }
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
        print3d(node.origin + (0, 0, 2), i, (1, 1, 1), 1, 0.3, 1);

        edges = getEdgesFrom(i);
        if (!isDefined(edges))
            continue;

        for (j = 0; j < edges.size; j += 1)
        {
            start = node.origin + (0, 0, 1);
            endNode = getNode(edges[j]);
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

isOriginAlreadyInNodes(origin)
{
    for (i = 0; i < level.nodes.size; i += 1)
    {
        dist = distanceSquared(origin, level.nodes[i].origin);
        if (dist < 10)
            return true;
    }

    return false;
}

isOriginAccesibleFromOther(fromOrigin, toOrigin)
{
    trace = bulletTrace(fromOrigin + (0, 0, 2), toOrigin + (0, 0, 2), false, undefined);
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
    
    level.edges[from + ""][level.edges[from + ""].size] = to;
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
