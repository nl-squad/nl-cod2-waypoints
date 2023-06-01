#include blanco\tests;
#include blanco\chunks;

Main()
{
    test("ChunksCreate__ShouldCreateEmptyChunks", ::ChunksCreate__ShouldCreateEmptyChunks);
    test("ChunksInsert__ShouldInsertElementIntoChunks", ::ChunksInsert__ShouldInsertElementIntoChunks);
    test("ChunksDeleteAndInsert__ShouldNotChangeIDsOfOtherElements", ::ChunksDeleteAndInsert__ShouldNotChangeIDsOfOtherElements);
    test("ChunksGetElementsInSquaredDistance__ShouldReturnElementsInGivenSquaredDistance", ::ChunksGetElementsInSquaredDistance__ShouldReturnElementsInGivenSquaredDistance);
    test("ChunksGetElementsInSquaredDistance__ShouldNotReturnElementsOutOfGivenSquaredDistance", ::ChunksGetElementsInSquaredDistance__ShouldNotReturnElementsOutOfGivenSquaredDistance);
    test("ChunksGetElementsInSquaredDistance__ShouldNotReturnElementsOnBorderOfChunks", ::ChunksGetElementsInSquaredDistance__ShouldNotReturnElementsOnBorderOfChunks);
}

ChunksCreate__ShouldCreateEmptyChunks()
{
    chunks = ChunksCreate(100);
    assert(chunks.nextUid == 0);
}

ChunksInsert__ShouldInsertElementIntoChunks()
{
    chunks = ChunksCreate(100);
    element = spawnStruct();
    element.origin = [200, 300, 400];
    uid = ChunksInsert(chunks, element);

    assert(isDefined(ChunksGetElement(chunks, uid)));
}

ChunksDelete__ShouldStillMakeItPossibleToGetAllElements()
{
    chunks = ChunksCreate(100);
    id1 = ChunksInsert(chunks, createStructWithOrigin(200, 300, 400));
    id2 = ChunksInsert(chunks, createStructWithOrigin(100, 300, 400));
    id3 = ChunksInsert(chunks, createStructWithOrigin(300, 300, 400));

    ChunksDelete(chunks, id1);

    elements = ChunksGetAllElements(chunks);

    assert(elements.size == 2);
    assert(elements[0].uid = id2);
    assert(elements[1].uid = id3);
}

ChunksDeleteAndInsert__ShouldNotChangeIDsOfOtherElements()
{
    chunks = ChunksCreate(100);
    element1 = createStructWithOrigin(200, 300, 400);
    id1 = ChunksInsert(chunks, element1);

    element2 = createStructWithOrigin(300, 400, 500);
    id2 = ChunksInsert(chunks, element2);

    ChunksDelete(chunks, id1);
    
    assert(ChunksGetElement(chunks, id2) == element2);

    element3 = createStructWithOrigin(500, 600, 700);
    id3 = ChunksInsert(chunks, element3);

    assert(id3 != id1);
    assert(ChunksGetElement(chunks, id3) == element3);
}

ChunksGetElementsInSquaredDistance__ShouldReturnElementsInGivenSquaredDistance()
{
    chunks = ChunksCreate(100);
    element1 = createStructWithOrigin(200, 300, 400);
    uid1 = ChunksInsert(chunks, element1);

    element2 = createStructWithOrigin(300, 400, 500);
    uid2 = ChunksInsert(chunks, element2);
    
    elements = ChunksGetElementsInSquaredDistance(chunks, [250, 350, 450], 20000);

    assert(elements.size == 2);
    assert(isDefined(ChunksGetElement(chunks, uid1)));
    assert(isDefined(ChunksGetElement(chunks, uid2)));
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

    elements = ChunksGetElementsInSquaredDistance(chunks, [0, 0, 0], 100);

    assert(elements.size == 5);
}

ChunksGetElementsInSquaredDistance__ShouldNotReturnElementsOnBorderOfChunks()
{
    chunks = ChunksCreate(10);
    ChunksInsert(chunks, createStructWithOrigin(10, 20, 30));
    ChunksInsert(chunks, createStructWithOrigin(30, 20, 30));
    ChunksInsert(chunks, createStructWithOrigin(0, 0, 0));

    elements = ChunksGetElementsInSquaredDistance(chunks, [20, 20, 30], 100);

    assert(elements.size == 2);
}

createStructWithOrigin(x, y, z)
{
    struct = spawnStruct();
    struct.origin = [x, y, z];
    return struct;
}
