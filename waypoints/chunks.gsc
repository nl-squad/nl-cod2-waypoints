
ChunksCreate(chunkSize)
{
    chunks = spawnStruct();
    chunks.chunkSize = chunkSize;
    chunks.elements = [];
    chunks.dictionary = [];
    chunks.nextUid = 1;

    return chunks;
}

ChunksInsert(chunks, element)
{
    assert(isDefined(element.origin));

    uid = chunks.nextUid;
    chunks.nextUid += 1;

    element.uid = uid;
    chunks.elements[uid] = element;

    x = int(element.origin[0] / chunks.chunkSize) + "";
    y = int(element.origin[1] / chunks.chunkSize) + "";
    z = int(element.origin[2] / chunks.chunkSize) + "";

    if (!isDefined(chunks.dictionary[x]))
        chunks.dictionary[x] = [];

    if (!isDefined(chunks.dictionary[x][y]))
        chunks.dictionary[x][y] = [];

    if (!isDefined(chunks.dictionary[x][y][z]))
        chunks.dictionary[x][y][z] = [];

    chunks.dictionary[x][y][z][chunks.dictionary[x][y][z].size] = uid;

    return uid;
}

ChunksGetAllElements(chunks)
{
    return chunks.elements;
}

ChunksGetElement(chunks, uid)
{
    return chunks.elements[uid];
}

ChunksDelete(chunks, uid)
{
    assert(isDefined(chunks.elements[uid]));

    element = chunks.elements[uid];
    x = int(element.origin[0] / chunks.chunkSize) + "";
    y = int(element.origin[1] / chunks.chunkSize) + "";
    z = int(element.origin[2] / chunks.chunkSize) + "";

    assert(isDefined(chunks.dictionary[x]));
    assert(isDefined(chunks.dictionary[x][y]));
    assert(isDefined(chunks.dictionary[x][y][z]));

    uids = chunks.dictionary[x][y][z];
    newUids = [];
    for (i = 0; i < uids.size; i++)
        if (uids[i] != uid)
            newUids[newUids.size] = uids[i];

    chunks.dictionary[x][y][z] = newUids;
    chunks.elements[uid] = undefined;
}

ChunksGetElementsInSquaredDistance(chunks, origin, squaredDistance)
{
    chunkRange = ceil(squaredDistance / (chunks.chunkSize * chunks.chunkSize));

    xOriginChunk = int(origin[0] / chunks.chunkSize);
    yOriginChunk = int(origin[1] / chunks.chunkSize);
    zOriginChunk = int(origin[2] / chunks.chunkSize);

    indices = [];

    for (xOffset = -1 * chunkRange; xOffset <= chunkRange; xOffset++)
    {
        for (yOffset = -1 * chunkRange; yOffset <= chunkRange; yOffset++)
        {
            for (zOffset = -1 * chunkRange; zOffset <= chunkRange; zOffset++)
            {
                x = (xOriginChunk + xOffset) + "";
                y = (yOriginChunk + yOffset) + "";
                z = (zOriginChunk + zOffset) + "";

                chunkIndices = getIndicesFromChunk(chunks, x, y, z);
                for (i = 0; i < chunkIndices.size; i += 1)
                    indices[indices.size] = chunkIndices[i];
            }
        }
    }

    filteredElements = [];
    for (i = 0; i < indices.size; i += 1)
    {
        element = chunks.elements[indices[i]];
        if (distanceSquared(origin, element.origin) <= squaredDistance)
            filteredElements[filteredElements.size] = element;
    }

    return filteredElements;
}

getIndicesFromChunk(chunks, x, y, z)
{
    if (!isDefined(chunks.dictionary[x])
        || !isDefined(chunks.dictionary[x][y])
        || !isDefined(chunks.dictionary[x][y][z]))
        return [];

    return chunks.dictionary[x][y][z];
}

ceil(num)
{
    floor = int(num);
    if (num == floor)
        return floor;

    return floor + 1;
}
