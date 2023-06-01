
ChunksCreate(chunkSize)
{
    chunks = spawnStruct();
    chunks.chunkSize = chunkSize;
    chunks.elements = [];
    chunks.dictionary = [];

    return chunks;
}

ChunksInsert(chunks, element)
{
    assert(isDefined(element.origin));

    x = int(element.origin[0] / chunks.chunkSize) + "";
    y = int(element.origin[1] / chunks.chunkSize) + "";
    z = int(element.origin[2] / chunks.chunkSize) + "";

    if (!isDefined(chunks.dictionary[x]))
        chunks.dictionary[x] = [];

    if (!isDefined(chunks.dictionary[x][y]))
        chunks.dictionary[x][y] = [];

    if (!isDefined(chunks.dictionary[x][y][z]))
        chunks.dictionary[x][y][z] = [];

    n = chunks.elements.size;
    chunks.elements[n] = element;
    chunks.dictionary[x][y][z][chunks.dictionary[x][y][z].size] = n;

    return n;
}

ChunksGetAllElements(chunks)
{
    return chunks.elements;
}

ChunksGetElement(chunks, index)
{
    return chunks.elements[index];
}

ChunksGetElementsInSquaredDistance(chunks, origin, squaredDistance)
{
    chunkRange = ceil(squaredDistance / (chunks.chunkSize * chunks.chunkSize));

    xOriginChunk = int(origin[0] / chunks.chunkSize);
    yOriginChunk = int(origin[1] / chunks.chunkSize);
    zOriginChunk = int(origin[2] / chunks.chunkSize);

    indices = [];

    for (xOffset = -chunkRange; xOffset <= chunkRange; xOffset++)
    {
        for (yOffset = -chunkRange; yOffset <= chunkRange; yOffset++)
        {
            for (zOffset = -chunkRange; zOffset <= chunkRange; zOffset++)
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
    if (num == int(num))
        return num;

    return int(num) + 1;
}
