
NodesCreate(nodeSize)
{
    nodes = spawnStruct();
    nodes.nodeSize = nodeSize;
    nodes.elements = [];
    nodes.dictionary = [];
    nodes.nextUid = 1;

    return nodes;
}

NodesInsert(nodes, element)
{
    assert(isDefined(element.origin));

    uid = nodes.nextUid;
    nodes.nextUid += 1;

    element.uid = uid;
    nodes.elements[uid] = element;

    x = int(element.origin[0] / nodes.nodeSize) + "";
    y = int(element.origin[1] / nodes.nodeSize) + "";
    z = int(element.origin[2] / nodes.nodeSize) + "";

    if (!isDefined(nodes.dictionary[x]))
        nodes.dictionary[x] = [];

    if (!isDefined(nodes.dictionary[x][y]))
        nodes.dictionary[x][y] = [];

    if (!isDefined(nodes.dictionary[x][y][z]))
        nodes.dictionary[x][y][z] = [];

    nodes.dictionary[x][y][z][nodes.dictionary[x][y][z].size] = uid;

    return uid;
}

NodesGetAllElements(nodes)
{
    return nodes.elements;
}

NodesGetElement(nodes, uid)
{
    return nodes.elements[uid];
}

NodesDelete(nodes, uid)
{
    assert(isDefined(nodes.elements[uid]));

    element = nodes.elements[uid];
    x = int(element.origin[0] / nodes.nodeSize) + "";
    y = int(element.origin[1] / nodes.nodeSize) + "";
    z = int(element.origin[2] / nodes.nodeSize) + "";

    assert(isDefined(nodes.dictionary[x]));
    assert(isDefined(nodes.dictionary[x][y]));
    assert(isDefined(nodes.dictionary[x][y][z]));

    uids = nodes.dictionary[x][y][z];
    newUids = [];
    for (i = 0; i < uids.size; i++)
        if (uids[i] != uid)
            newUids[newUids.size] = uids[i];

    nodes.dictionary[x][y][z] = newUids;
    nodes.elements[uid] = undefined;
}

NodesGetElementsInSquaredDistance(nodes, origin, squaredDistance)
{
    nodeRange = ceil(squaredDistance / (nodes.nodeSize * nodes.nodeSize));

    xOriginNode = int(origin[0] / nodes.nodeSize);
    yOriginNode = int(origin[1] / nodes.nodeSize);
    zOriginNode = int(origin[2] / nodes.nodeSize);

    indices = [];

    for (xOffset = -1 * nodeRange; xOffset <= nodeRange; xOffset++)
    {
        for (yOffset = -1 * nodeRange; yOffset <= nodeRange; yOffset++)
        {
            for (zOffset = -1 * nodeRange; zOffset <= nodeRange; zOffset++)
            {
                x = (xOriginNode + xOffset) + "";
                y = (yOriginNode + yOffset) + "";
                z = (zOriginNode + zOffset) + "";

                nodeIndices = getIndicesFromNode(nodes, x, y, z);
                for (i = 0; i < nodeIndices.size; i += 1)
                    indices[indices.size] = nodeIndices[i];
            }
        }
    }

    filteredElements = [];
    for (i = 0; i < indices.size; i += 1)
    {
        element = nodes.elements[indices[i]];
        if (distanceSquared(origin, element.origin) <= squaredDistance)
            filteredElements[filteredElements.size] = element;
    }

    return filteredElements;
}

getIndicesFromNode(nodes, x, y, z)
{
    if (!isDefined(nodes.dictionary[x])
        || !isDefined(nodes.dictionary[x][y])
        || !isDefined(nodes.dictionary[x][y][z]))
        return [];

    return nodes.dictionary[x][y][z];
}

ceil(num)
{
    floor = int(num);
    if (num == floor)
        return floor;

    return floor + 1;
}
