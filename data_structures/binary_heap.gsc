HeapCreate(compareFunction)
{
    heap = spawnStruct();
    heap.compareFunction = compareFunction;
    heap.elements = [];

    return heap;
}

HeapInsert(heap, element)
{
    heap.elements[heap.elements.size] = element;
    bubbleUp(heap, heap.elements.size - 1);
}

HeapPop(heap)
{
    if (heap.elements.size == 0)
        return undefined;

    minElement = heap.elements[0];

    heap.elements[0] = heap.elements[heap.elements.size - 1];
    heap.elements[heap.elements.size - 1] = undefined;
    bubbleDown(heap, 0);

    return minElement;
}

bubbleUp(heap, index)
{
    if (index == 0)
        return;

    parentIndex = int((index - 1) / 2);

    if ([[ heap.compareFunction ]](heap.elements[parentIndex], heap.elements[index]) <= 0)
        return;

    temp = heap.elements[parentIndex];
    heap.elements[parentIndex] = heap.elements[index];
    heap.elements[index] = temp;

    bubbleUp(heap, parentIndex);
}

bubbleDown(heap, index)
{
    childIndex1 = 2 * index + 1;
    childIndex2 = 2 * index + 2;

    if (childIndex1 >= heap.elements.size)
        return;

    // If the node has two children, choose the smaller one using compareFunction
    if (childIndex2 < heap.elements.size
        && [[ heap.compareFunction ]](heap.elements[childIndex2], heap.elements[childIndex1]) < 0)
        childIndex1 = childIndex2;

    // If the child's cost is less than the parent's cost, swap them
    if ([[ heap.compareFunction ]](heap.elements[childIndex1], heap.elements[index]) >= 0)
        return;

    temp = heap.elements[childIndex1];
    heap.elements[childIndex1] = heap.elements[index];
    heap.elements[index] = temp;

    bubbleDown(heap, childIndex1);
}
