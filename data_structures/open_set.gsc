OpenSetCreate()
{
    openSet = spawnStruct();
    openSet.currentIndex = 0;
    openSet.objects = [];
    return openSet;
}

OpenSetInsert(openSet, element)
{
    openSet.objects[openSet.objects.size] = element;
}

OpenSetPop(openSet)
{
    n = openSet.currentIndex;
    openSet.currentIndex += 1;
    return openSet.objects[n];
}
