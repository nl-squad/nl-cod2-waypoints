#include blanco\data_structures\edges;
#include blanco\data_structures\nodes;
#include blanco\data_structures\open_set;

Main()
{
    setCvar("developer", "2");
    setCvar("developer_script", "1");

    level.GRID_SIZE = 64;
    level.CHUNKS_SIZE = 256;
    level.MAX_ITERATIONS = 1000;
    level.EDGE_STAND = 1;
    level.EDGE_CROUCH = 2;
    level.EDGE_PRONE = 3;
    level.EDGE_JUMP = 4;
    level.EDGE_LADDER = 5;

    level.DISCOVER_Z_OFFSET = 32;
    level.DISCOVER_MAX_DROPDOWN = 300;
    level.MINIMUM_SPACE_BETWEEN_NODES_SQUARED = level.GRID_SIZE * level.GRID_SIZE / 2;

    resetGraph();
}

Start(startOrigin)
{
    resetGraph();

    nodeUid = NodesInsert(level.nodes, startOrigin);
    interationsCount = 0;

    while(isDefined(nodeUid) && interationsCount < level.MAX_ITERATIONS)
    {
        discoverFromNode(nodeUid, false);
        nodeUid = OpenSetPop(level.openSet);
        interationsCount += 1;

        if (interationsCount % 500 == 0)
        {
            iPrintLn("1s break");
            wait 1;
        }
    }

    nodesCount = NodesGetAllElements(level.nodes).size;
    printLn("Discovered " + nodesCount + " nodes.");
    iPrintLn("Discovered ^2" + nodesCount + " ^7nodes.");
}

resetGraph()
{
    level.nodes = NodesCreate(level.CHUNKS_SIZE);
    level.edges = EdgesCreate();
    level.openSet = OpenSetCreate();
}

discoverFromNode(nodeUid, isDebug)
{
    node = NodesGetElement(level.nodes, nodeUid);
    neighbours = getNeighbours(node.origin, isDebug);

    for (i = 0; i < neighbours.size; i += 1)
    {
        neighbour = neighbours[i];

        existingNode = NodesGetClosestElementInSquareDistance(level.nodes, neighbour.origin, level.MINIMUM_SPACE_BETWEEN_NODES_SQUARED, nodeUid);
        if (isDefined(existingNode))
        {
            if (isDebug)
                blanco\waypoints\draw::AddPrint(neighbour.origin, "Already", (0.2, 0.6, 0.99));

            if (EdgesExists(level.edges, nodeUid, existingNode.uid) || EdgesExists(level.edges, existingNode.uid, nodeUid))
                continue;

            edgeType = getEdgeType(node.origin, existingNode.origin);
            weight = distanceSquared(node.origin, existingNode.origin);

            if (isDefined(edgeType.typeTo))
                EdgesInsert(level.edges, nodeUid, existingNode.uid, weight, edgeType.typeTo);

            if (isDefined(edgeType.typeReverse))
                EdgesInsert(level.edges, existingNode.uid, nodeUid, weight, edgeType.typeReverse);

            continue;
        }

        insertedNodeId = NodesInsert(level.nodes, neighbour.origin);
        OpenSetInsert(level.openSet, insertedNodeId);

        weight = distanceSquared(node.origin, neighbour.origin);

        if (isDebug)
            blanco\waypoints\draw::AddPrint(neighbour.origin, "New", (0.2, 0.6, 0.99));

        if (isDefined(neighbour.typeTo))
            EdgesInsert(level.edges, nodeUid, insertedNodeId, weight, neighbour.typeTo);

        if (isDefined(neighbour.typeReverse))
            EdgesInsert(level.edges, insertedNodeId, nodeUid, weight, neighbour.typeReverse);
    }
}

getNeighbours(origin, isDebug)
{
    neighbours = [];
    directions = getSearchDirections();

    for (i = 0; i < directions.size; i += 1)
    {
        direction = directions[i];

        newOrigin = capTrace(origin, origin + (0, 0, level.DISCOVER_Z_OFFSET), isDebug);

        directionOrigin = newOrigin + maps\mp\_utility::vectorScale(direction, level.GRID_SIZE);
        directionOrigin = capTrace(newOrigin, directionOrigin, isDebug);

        onGroundOrigin = putOnTheGround(directionOrigin, isDebug);
        if (!isDefined(onGroundOrigin))
            continue;

        edgeType = getEdgeType(origin, onGroundOrigin);
        if (!isDefined(edgeType.typeTo) && !isDefined(edgeType.typeReverse))
            continue;

        neighbour = spawnStruct();
        neighbour.origin = onGroundOrigin;
        neighbour.typeTo = edgeType.typeTo;
        neighbour.typeReverse = edgeType.typeReverse;
        neighbours[neighbours.size] = neighbour;
    }

    return neighbours;
}

capTrace(firstOrigin, secondOrigin, isDebug)
{
    trace = bulletTrace(firstOrigin, secondOrigin, false, undefined);
    if (trace["fraction"] < 1)
    {
        if (isDebug)
            blanco\waypoints\draw::AddLine(firstOrigin, trace["position"], (1, 0.37, 0.12));

        return trace["position"];
    }

    if (isDebug)
        blanco\waypoints\draw::AddLine(firstOrigin, secondOrigin, (0, 1, 0));

    return secondOrigin;
}

putOnTheGround(origin, isDebug)
{
    trace = bulletTrace(origin, origin - (0, 0, level.DISCOVER_MAX_DROPDOWN), false, undefined);
    if (trace["fraction"] < 1)
    {
        if (isDebug)
            blanco\waypoints\draw::AddLine(origin, trace["position"], (0, 1, 0));

        return trace["position"];
    }

    if (isDebug)
        blanco\waypoints\draw::AddLine(origin, origin - (0, 0, level.DISCOVER_MAX_DROPDOWN), (1, 0, 0));

    return undefined;
}

getSearchDirections()
{
    directions = [];
    directions[directions.size] = (1, 0, 0);
    directions[directions.size] = (-1, 0, 0);
    directions[directions.size] = (0, 1, 0);
    directions[directions.size] = (0, -1, 0);

    return directions;
}

getEdgeType(firstOrigin, secondOrigin)
{
    return EdgeType(level.EDGE_STAND, level.EDGE_STAND);

    // TODO: if slope to steep
    //     return undefined

    // if spaceOverHeadA or spavOverHeadB < prone minimal
    //     return undefined

    // if spaceOverHeadA or spavOverHeadB < crouch minimal
    //     return prone

    // if spaceOverHeadA or spaceOverHeadB < stand minimal
    //     return crouch

    // if bullettrace not clear and node.z > neighbour.z
    //     return jump

    // return stand
}

EdgeType(typeTo, typeReverse)
{
    edgeType = spawnStruct();
    edgeType.typeTo = typeTo;
    edgeType.typeReverse = typeReverse;
    return edgeType;
}

// F // Chaning edge type
// command // Re-run generation
// command // Clear
// F + melee // Creating path - replace points in grid with manually added
// Edge types - jump, crouch, prone, ladder

// mantle, elevators, teleporters, ladders