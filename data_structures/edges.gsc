
EdgesCreate()
{
    edges = spawnStruct();
    edges.chunkSize = chunkSize;
    edges.elements = [];
    edges.fromDictionary = [];
    edges.toDictionary = [];
    edges.chunks = [];

    return edges;
}

EdgesInsert(edges, fromUid, toUid, weight, type, selectOrigin, chunkSize)
{
    edgeStruct = spawnStruct();
    edgeStruct.fromUid = fromUid;
    edgeStruct.toUid = toUid;
    edgeStruct.weight = weight;
    edgeStruct.type = type;
    edgeStruct.selectOrigin = selectOrigin;

    edges.elements[getKey(fromUid, toUid)] = edgeStruct;

    if (!isDefined(edges.fromDictionary[fromUid]))
        edges.fromDictionary[fromUid] = [];

    edges.fromDictionary[fromUid][edges.fromDictionary[fromUid].size] = edgeStruct;

    if (!isDefined(edges.toDictionary[toUid]))
        edges.toDictionary[toUid] = [];

    edges.toDictionary[toUid][edges.toDictionary[toUid].size] = edgeStruct;

    x = int(selectOrigin[0] / chunkSize) + "";
    y = int(selectOrigin[1] / chunkSize) + "";
    z = int(selectOrigin[2] / chunkSize) + "";

    if (!isDefined(edges.chunks[x]))
        edges.chunks[x] = [];

    if (!isDefined(edges.chunks[x][y]))
        edges.chunks[x][y] = [];

    if (!isDefined(edges.chunks[x][y][z]))
        edges.chunks[x][y][z] = [];

    edges.chunks[x][y][z][edges.chunks[x][y][z].size] = edgeStruct;
}

EdgesDelete(edges, fromUid, toUid)
{
    key = getKey(fromUid, toUid);
    assert(isDefined(edges.elements[key]));


    newFromEdges = [];
    for (i = 0; i < edges.fromDictionary[fromUid].size; i += 1)
        if (edges.fromDictionary[fromUid][i].toUid != toUid)
            newFromEdges[newFromEdges.size] = edges.fromDictionary[fromUid][i];

    edges.fromDictionary[fromUid] = newFromEdges;


    newToEdges = [];
    for (i = 0; i < edges.toDictionary[toUid].size; i += 1)
        if (edges.toDictionary[toUid][i].fromUid != fromUid)
            newToEdges[newToEdges.size] = edges.toDictionary[toUid][i];
    
    edges.toDictionary[toUid] = newToEdges;


    edge = edges.elements[key];
    x = int(edge.selectOrigin[0] / edges.chunkSize) + "";
    y = int(edge.selectOrigin[1] / edges.chunkSize) + "";
    z = int(edge.selectOrigin[2] / edges.chunkSize) + "";

    newEdgesInChunk = [];
    for (i = 0; i < edges.chunks[x][y][z].size; i += 1)
        if (edges.chunks[x][y][z][i].fromUid != fromUid || edges.chunks[x][y][z][i].toUid != toUid)
            newEdgesInChunk[newEdgesInChunk.size] = edges.chunks[x][y][z][i];

    edges.chunks[x][y][z] = newEdgesInChunk;


    edges.elements[key] = undefined;
}

EdgesDeleteFrom(edges, fromUid)
{
    if (!isDefined(edges.fromDictionary[fromUid]))
        return;

    for (i = 0; i < edges.fromDictionary[fromUid].size; i += 1)
        EdgesDelete(edges, fromUid, edges.fromDictionary[fromUid][i].toUid);
}

EdgesDeleteTo(edges, toUid)
{
    if (!isDefined(edges.toDictionary[toUid]))
        return;

    for (i = 0; i < edges.toDictionary[toUid].size; i += 1)
        EdgesDelete(edges, edges.toDictionary[toUid][i].fromUid, toUid);
}

EdgesGetFrom(edges, fromUid)
{
    if (!isDefined(edges.fromDictionary[fromUid]))
        return [];

    return edges.fromDictionary[fromUid];
}

EdgesGetTo(edges, toUid)
{
    if (!isDefined(edges.toDictionary[toUid]))
        return [];

    return edges.toDictionary[toUid];
}

EdgesExists(edges, fromUid, toUid)
{
    return isDefined(edges.elements[getKey(fromUid, toUid)]);
}

EdgesGet(edges, fromUid, toUid)
{
    return edges.elements[getKey(fromUid, toUid)];
}

EdgesChangeType(edges, fromUid, toUid newType)
{
    edge = EdgesGet(edges, fromUid, toUid);

    if (!isDefined(newType))
        newType = (edge.type + 1) % level.EDGE_TYPES_COUNT;

    edge.type = newType;
    return edge.type;
}

EdgesCalculateSelectOrigins(startOrigin, endOrigin)
{
    midDistance = distance(startOrigin, endOrigin) / 2;
    normal = vectorNormalize(endOrigin - startOrigin);

    selectOrigins = spawnStruct();
    selectOrigins.toUid = startOrigin + maps\mp\_utility::vectorScale(normal, midDistance - level.EDGE_SELECTOR_OFFSET);
    selectOrigins.reverse = startOrigin + maps\mp\_utility::vectorScale(normal, midDistance + level.EDGE_SELECTOR_OFFSET);
    return selectOrigins;
}

EdgesGetClosestElementInSquareDistance(edges, origin, squaredDistance)
{
    elements = EdgesGetElementsInSquaredDistance(edges, origin, squaredDistance);

    best = undefined;
    bestDistance = 0;

    for (i = 0; i < elements.size; i += 1)
    {
        dist = distanceSquared(origin, elements[i].selectOrigin);
        if (!isDefined(best) || dist < bestDistance)
        {
            best = elements[i];
            bestDistance = dist;
        }
    }

    return best;
}

EdgesGetElementsInSquaredDistance(edges, origin, squaredDistance)
{
    range = ceil(squaredDistance / (edges.chunkSize * edges.chunkSize));

    chunkX = int(origin[0] / edges.chunkSize);
    chunkY = int(origin[1] / edges.chunkSize);
    chunkZ = int(origin[2] / edges.chunkSize);

    edgesFound = [];

    for (xOffset = -1 * range; xOffset <= range; xOffset++)
    {
        for (yOffset = -1 * range; yOffset <= range; yOffset++)
        {
            for (zOffset = -1 * range; zOffset <= range; zOffset++)
            {
                x = (chunkX + xOffset) + "";
                y = (chunkY + yOffset) + "";
                z = (chunkZ + zOffset) + "";

                edgesInChunk = getEdgesInChunk(edges, x, y, z);
                for (i = 0; i < edgesInChunk.size; i += 1)
                    if (distanceSquared(origin, edgesInChunk[i].selectOrigin) <= squaredDistance)
                        edgesFound[edgesFound.size] = edgesInChunk[i];
            }
        }
    }

    return edgesFound;
}

getEdgesInChunk(edges, x, y, z)
{
    if (!isDefined(edges.chunks[x])
        || !isDefined(edges.chunks[x][y])
        || !isDefined(edges.chunks[x][y][z]))
        return [];

    return edges.dictionary[x][y][z];
}

getKey(fromUid, toUid)
{
    return fromUid + "_" + toUid;
}
