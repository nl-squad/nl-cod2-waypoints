
ChunksCreate(chunkSize)
{
    chunks = spawnStruct();
    chunks.chunkSize = chunkSize;
    chunks.elements = [];

    return chunks;
}

ChunksInsert(chunks, element)
{
    assert(isDefined(element.origin));

    x = int(element.origin[0] / chunks.chunkSize) + "";
    y = int(element.origin[1] / chunks.chunkSize) + "";
    z = int(element.origin[2] / chunks.chunkSize) + "";

    if (!isDefined(chunks.elements[x]))
        chunks.elements[x] = [];

    if (!isDefined(chunks.elements[x][y]))
        chunks.elements[x][y] = [];

    if (!isDefined(chunks.elements[x][y][z]))
        chunks.elements[x][y][z] = [];

    chunks.elements[x][y][z][chunks.elements[x][y][z].size] = element;
}

ChunksGetElementsInSquaredDistance(chunks, origin, squaredDistance)
{
    chunkRange = ceil(squaredDistance / (chunks.chunkSize * chunks.chunkSize));

    xOriginChunk = int(origin[0] / chunks.chunkSize);
    yOriginChunk = int(origin[1] / chunks.chunkSize);
    zOriginChunk = int(origin[2] / chunks.chunkSize);

    elements = [];

    for (xOffset = -chunkRange; xOffset <= chunkRange; xOffset++)
    {
        for (yOffset = -chunkRange; yOffset <= chunkRange; yOffset++)
        {
            for (zOffset = -chunkRange; zOffset <= chunkRange; zOffset++)
            {
                x = (xOriginChunk + xOffset) + "";
                y = (yOriginChunk + yOffset) + "";
                z = (zOriginChunk + zOffset) + "";

                chunkElements = getElementsFromChunk(chunks, x, y, z);
                for (i = 0; i < chunkElements.size; i += 1)
                    elements[elements.size] = chunkElements[i];
            }
        }
    }

    filteredElements = [];
    for (i = 0; i < elements.size; i += 1)
        if (distanceSquared(origin, elements[i].origin) <= squaredDistance)
            filteredElements[filteredElements.size] = elements[i];

    return filteredElements;
}

getElementsFromChunk(chunks, x, y, z)
{
    if (!isDefined(chunks.elements[x])
        || !isDefined(chunks.elements[x][y])
        || !isDefined(chunks.elements[x][y][z]))
        return [];

    return chunks.elements[x][y][z];
}

ceil(num)
{
    if (num == int(num))
        return num;

    return int(num) + 1;
}
