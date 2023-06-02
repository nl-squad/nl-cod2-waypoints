#include blanco\tests;
#include blanco\waypoints\binary_heap;

Main()
{
    test("HeapCreate__ShouldCreateEmptyHeap", ::HeapCreate__ShouldCreateEmptyHeap);
    test("HeapInsert__ShouldIncreaseHeapSize", ::HeapInsert__ShouldIncreaseHeapSize);
    test("HeapPop__ShouldReturnSmallestElementAndReduceHeapSize", ::HeapPop__ShouldReturnSmallestElementAndReduceHeapSize);
    test("HeapPop__ShouldHandleStructs", ::HeapPop__ShouldHandleStructs);
    test("HeapPop__ResultsInSortedItems", ::HeapPop__ResultsInSortedItems);
}

HeapCreate__ShouldCreateEmptyHeap()
{
    heap = HeapCreate(::compareFunction);

    assert(heap.elements.size == 0);
}

HeapInsert__ShouldIncreaseHeapSize()
{
    heap = HeapCreate(::compareFunction);

    HeapInsert(heap, 10);

    assert(heap.elements.size == 1);
}

HeapPop__ShouldReturnSmallestElementAndReduceHeapSize()
{
    heap = HeapCreate(::compareFunction);
    HeapInsert(heap, 10);
    HeapInsert(heap, 3);
    HeapInsert(heap, -2);
    HeapInsert(heap, 5);

    minElement = HeapPop(heap);

    assert(heap.elements.size == 3);
    assert(minElement == -2);
}

HeapPop__ShouldHandleStructs()
{
    heap = HeapCreate(::compareStructFunction);
    HeapInsert(heap, createStruct(10));
    HeapInsert(heap, createStruct(1));
    HeapInsert(heap, createStruct(3));
    HeapInsert(heap, createStruct(4));
    HeapInsert(heap, createStruct(0));
    HeapInsert(heap, createStruct(1));

    minElement = HeapPop(heap);

    assert(heap.elements.size == 5);
    assert(minElement.value == 0);
}

HeapPop__ResultsInSortedItems()
{
    heap = HeapCreate(::compareFunction);
    HeapInsert(heap, 4);
    HeapInsert(heap, 8);
    HeapInsert(heap, 2);
    HeapInsert(heap, 1);
    HeapInsert(heap, 7);
    HeapInsert(heap, 6);
    HeapInsert(heap, 3);
    HeapInsert(heap, 5);
    HeapInsert(heap, 9);

    assert(HeapPop(heap) == 1);
    assert(HeapPop(heap) == 2);
    assert(HeapPop(heap) == 3);
    assert(HeapPop(heap) == 4);
    assert(HeapPop(heap) == 5);
    assert(HeapPop(heap) == 6);
    assert(HeapPop(heap) == 7);
    assert(HeapPop(heap) == 8);
    assert(HeapPop(heap) == 9);
}

compareFunction(a, b)
{
    if (a < b)
        return -1;
    else if (a > b)
        return 1;
    else
        return 0;
}

createStruct(value)
{
    struct = spawnStruct();
    struct.value = value;
    return struct;
}

compareStructFunction(a, b)
{
    if (a.value < b.value)
        return -1;
    else if (a.value > b.value)
        return 1;
    else
        return 0;
}
