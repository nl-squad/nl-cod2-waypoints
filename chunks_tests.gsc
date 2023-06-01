#include blanco\chunks;
#include blanco\tests;

Main()
{
    test("ChunksCreate__ShouldCreateEmptyChunks", ::ChunksCreate__ShouldCreateEmptyChunks);
    test("ChunksInsert__ShouldInsertElementIntoChunks", ::ChunksInsert__ShouldInsertElementIntoChunks);
    test("ChunksGetElementsInSquaredDistance__ShouldReturnElementsInGivenSquaredDistance", ::ChunksGetElementsInSquaredDistance__ShouldReturnElementsInGivenSquaredDistance);
    test("ChunksGetElementsInSquaredDistance__ShouldNotReturnElementsOutOfGivenSquaredDistance", ::ChunksGetElementsInSquaredDistance__ShouldNotReturnElementsOutOfGivenSquaredDistance);
    test("ChunksGetElementsInSquaredDistance__ShouldNotReturnElementsOnBorderOfChunks", ::ChunksGetElementsInSquaredDistance__ShouldNotReturnElementsOnBorderOfChunks);
}

ChunksCreate__ShouldCreateEmptyChunks()
{
    chunks = ChunksCreate(100);
    assert(chunks.elements.size == 0);
}

ChunksInsert__ShouldInsertElementIntoChunks()
{
    chunks = ChunksCreate(100);
    element = spawnStruct();
    element.origin = [200, 300, 400];
    ChunksInsert(chunks, element);
    
    assert(chunks.elements["2"]["3"]["4"].size == 1);
    assert(chunks.elements["2"]["3"]["4"][0] == element);
}

ChunksGetElementsInSquaredDistance__ShouldReturnElementsInGivenSquaredDistance()
{
    chunks = ChunksCreate(100);
    element1 = createStructWithOrigin(200, 300, 400);
    ChunksInsert(chunks, element1);

    element2 = createStructWithOrigin(300, 400, 500);
    ChunksInsert(chunks, element2);
    
    elements = ChunksGetElementsInSquaredDistance(chunks, (250, 350, 450), 20000);

    assert(elements.size == 2);
    assert(elements[0] == element1);
    assert(elements[1] == element2);
}

ChunksGetElementsInSquaredDistance__ShouldNotReturnElementsOutOfGivenSquaredDistance()
{
    chunks = ChunksCreate(10);
    ChunksInsert(chunks, createStructWithOrigin(5, 0, 0));
    ChunksInsert(chunks, createStructWithOrigin(5, 0, 1));
    ChunksInsert(chunks, createStructWithOrigin(5, 10, 0));
    ChunksInsert(chunks, createStructWithOrigin(5, 0, 10));
    ChunksInsert(chunks, createStructWithOrigin(5, 1, 10));
    ChunksInsert(chunks, createStructWithOrigin(15, 0, 0));
    ChunksInsert(chunks, createStructWithOrigin(-5, 0, 0));
    ChunksInsert(chunks, createStructWithOrigin(-5.1, 0, 0));

    elements = ChunksGetElementsInSquaredDistance(chunks, (0, 0, 0), 100);

    assert(elements.size == 5);
}

ChunksGetElementsInSquaredDistance__ShouldNotReturnElementsOnBorderOfChunks()
{
    chunks = ChunksCreate(10);
    ChunksInsert(chunks, createStructWithOrigin(10, 20, 30));
    ChunksInsert(chunks, createStructWithOrigin(30, 20, 30));
    ChunksInsert(chunks, createStructWithOrigin(0, 0, 0));

    elements = ChunksGetElementsInSquaredDistance(chunks, (20, 20, 30), 100);

    assert(elements.size == 2);
}

createStructWithOrigin(x, y, z)
{
    struct = spawnStruct();
    struct.origin = (x, y, z);
    return struct;
}