HashArrayCreate()
{
    hashArray = spawnStruct();
    hashArray.objects = [];
    return hashArray;
}

HashArrayInsert(hashArray, element)
{
    object = spawnStruct();
    object.element = element;
    object.isDeleted = false;

    n = hashArray.objects.size;
    hashArray.objects[n] = object;

    return n;
}

HashArrayGet(hashArray, index)
{
    if (!isDefined(hashArray.objects[index])
        || hashArray.objects[index].isDeleted)
        return undefined;

    return hashArray.objects[index].element;
}

HashArrayDelete(hashArray, index)
{
    assert(isDefined(hashArray.objects[index]));
    assert(!hashArray.objects[index].isDeleted);

    hashArray.objects[index].isDeleted = true;
}

HashArrayGetNext(hashArray, currentIndex)
{
    if (!isDefined(currentIndex))
        currentIndex = -1;

    currentIndex += 1;

    while (currentIndex < hashArray.objects.size && hashArray.objects[currentIndex].isDeleted)
        currentIndex += 1;

    struct = spawnStruct();
    struct.currentIndex = currentIndex;

    if (currentIndex < hashArray.objects.size)
        struct.element = hashArray.objects[currentIndex].element;

    return struct;
}
