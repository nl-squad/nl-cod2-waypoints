
NodesCreate(chunkSize)
{
    nodes = spawnStruct();
    nodes.chunkSize = chunkSize;
    nodes.elements = [];
    nodes.chunks = [];
    nodes.nextUid = 1;

    return nodes;
}

NodesGet(nodes, uid)
{
    return nodes.elements[uid];
}

NodesInsert(nodes, origin)
{
    uid = nodes.nextUid;
    nodes.nextUid += 1;

    node = spawnStruct();
    node.origin = origin;
    node.uid = uid;
    nodes.elements[uid] = node;

    x = int(node.origin[0] / nodes.chunkSize) + "";
    y = int(node.origin[1] / nodes.chunkSize) + "";
    z = int(node.origin[2] / nodes.chunkSize) + "";

    if (!isDefined(nodes.chunks[x]))
        nodes.chunks[x] = [];

    if (!isDefined(nodes.chunks[x][y]))
        nodes.chunks[x][y] = [];

    if (!isDefined(nodes.chunks[x][y][z]))
        nodes.chunks[x][y][z] = [];

    nodes.chunks[x][y][z][nodes.chunks[x][y][z].size] = node;

    return node;
}

NodesDelete(nodes, uid)
{
    node = NodesGet(nodes, uid);
    x = int(node.origin[0] / nodes.chunkSize) + "";
    y = int(node.origin[1] / nodes.chunkSize) + "";
    z = int(node.origin[2] / nodes.chunkSize) + "";

    assert(isDefined(nodes.chunks[x]));
    assert(isDefined(nodes.chunks[x][y]));
    assert(isDefined(nodes.chunks[x][y][z]));

    newElements = [];
    for (i = 0; i < nodes.chunks[x][y][z].size; i++)
        if (nodes.chunks[x][y][z][i].uid != uid)
            newElements[newElements.size] = nodes.chunks[x][y][z][i];

    nodes.chunks[x][y][z] = newElements;

    nodes.elements[uid] = undefined;
}

NodesGetClosestElementInSquareDistance(nodes, origin, squaredDistance, currentNodeUid)
{
    elements = NodesGetElementsInSquaredDistance(nodes, origin, squaredDistance);

    best = undefined;
    bestDistance = 0;

    for (i = 0; i < elements.size; i += 1)
    {
        if (elements[i].uid == currentNodeUid)
            continue;

        dist = distanceSquared(origin, elements[i].origin);
        if (!isDefined(best) || dist < bestDistance)
        {
            best = elements[i];
            bestDistance = dist;
        }
    }

    return best;
}

NodesGetElementsInSquaredDistance(nodes, origin, squaredDistance)
{
    range = ceil(squaredDistance / (nodes.chunkSize * nodes.chunkSize));

    chunkX = int(origin[0] / nodes.chunkSize);
    chunkY = int(origin[1] / nodes.chunkSize);
    chunkZ = int(origin[2] / nodes.chunkSize);

    foundNodes = [];

    for (xOffset = -1 * range; xOffset <= range; xOffset++)
    {
        for (yOffset = -1 * range; yOffset <= range; yOffset++)
        {
            for (zOffset = -1 * range; zOffset <= range; zOffset++)
            {
                x = (chunkX + xOffset) + "";
                y = (chunkY + yOffset) + "";
                z = (chunkZ + zOffset) + "";

                nodesInChunk = getNodesInChunk(nodes, x, y, z);
                for (i = 0; i < nodesInChunk.size; i += 1)
                    if (distanceSquared(origin, nodesInChunk[i].origin) <= squaredDistance)
                        foundNodes[indices.size] = nodesInChunk[i];
            }
        }
    }

    return foundNodes;
}

getNodesInChunk(nodes, x, y, z)
{
    if (!isDefined(nodes.chunks[x])
        || !isDefined(nodes.chunks[x][y])
        || !isDefined(nodes.chunks[x][y][z]))
        return [];

    return nodes.chunks[x][y][z];
}

ceil(num)
{
    floor = int(num);
    if (num == floor)
        return floor;

    return floor + 1;
}
