Main()
{
    level.GRID_SIZE = 50;
    level.EDGE_STAND = 1;
    level.EDGE_CROUCH = 2;
    level.EDGE_PRONE = 3;
    level.EDGE_JUMP = 4;
    level.EDGE_LADDER = 4;

    level.DISCOVER_Z_OFFSET = 32;
    level.DISCOVER_MAX_DROPDOWN = 300;
    level.MINIMUM_SPACE_BETWEEN_NODES_SQUARED = level.GRID_SIZE * level.GRID_SIZE / 2;
}

Start(startOrigin)
{
    level.nodes = NodesCreate(level.GRID_SIZE);
    level.openSet = OpenSetCreate();

    startPoint = spawnStruct();
    startPoint.origin = startOrigin;
    nodeUid = NodesInsert(level.nodes, startPoint);

    while(isDefined(nodeUid))
    {
        discoverFromNode(nodeUid, false);
        nodeUid = OpenSetPop(level.openSet);
    }
}

discoverFromNode(nodeUid, isDebug)
{
    node = NodesGetElement(level.nodes, nodeUid);
    neighbours = getNeighbours(node.origin);

    for (i = 0; i < neighbours.size; i += 1)
    {
        neighbour = neighbours[i];

        if (NodesAlreadyHasNodeInSquaredDistance(level.nodes, neighbour.origin, level.MINIMUM_SPACE_BETWEEN_NODES_SQUARED))
            continue;

        insertedNodeId = NodesInsert(level.nodes, neighbour.origin);

        weight = distanceSquared(node.origin, neighbour.origin);
        EdgesInsert(level.edges, nodeUid, insertedNodeId, weight, neighbour.type);

        reverseEdgeType = getEdgeType(neighbour.origin, node.origin);
        if (isDefined(reverseEdgeType))
            EdgesInsert(level.edges, insertedNodeId, nodeUid, weight, reverseEdgeType);
    }
}

getNeighbours(origin)
{
    neighbours = [];
    directions = getSearchDirections();

    for (i = 0; i < directions.size; i += 1)
    {
        direction = directions[i];

        newOrigin = capTrace(origin, origin + (0, 0, level.DISCOVER_Z_OFFSET));

        directionOrigin = newOrigin + maps\mp\_utility::vectorScale(direction, level.GRID_SIZE);
        directionOrigin = capTrace(newOrigin, directionOrigin);

        // TODO: slope adjust

        onGroundOrigin = putOnTheGround(directionOrigin);
        if (!isDefined(onGroundOrigin))
            continue;
        
        type = getEdgeType(origin, onGroundOrigin);
        if (!isDefined(type))
            continue;

        neighbour = spawnStruct();
        neighbour.origin = onGroundOrigin;
        neighbour.type = type;
        neighbours[neighbours.size] = neighbour;
    }

    return neighbours;
}

capTrace(firstOrigin, secondOrigin)
{
    trace = bulletTrace(firstOrigin, secondOrigin, false, undefined);
    if (trace["fraction"] < 1)
        return trace["position"];

    return secondOrigin;
}

putOnTheGround(origin)
{
    trace = bulletTrace(origin + (0, 0, 1), origin - (0, 0, level.DISCOVER_MAX_DROPDOWN), false, undefined);
    if (trace["fraction"] < 1)
        return trace["position"];

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
    return level.EDGE_STAND;

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

// F // Chaning edge type
// command // Re-run generation
// command // Clear
// F + melee // Creating path - replace points in grid with manually added
// Edge types - jump, crouch, prone, ladder

// mantle, elevators, teleporters, ladders
