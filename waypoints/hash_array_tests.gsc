#include blanco\tests;
#include blanco\hasharray;

Main()
{
    test("HashArrayCreate__ShouldCreateEmptyHashArray", ::HashArrayCreate__ShouldCreateEmptyHashArray);
    test("HashArrayInsert__ShouldInsertElementIntoHashArray", ::HashArrayInsert__ShouldInsertElementIntoHashArray);
    test("HashArrayGet__ShouldGetInsertedElement", ::HashArrayGet__ShouldGetInsertedElement);
    test("HashArrayDelete__ShouldDeleteElement", ::HashArrayDelete__ShouldDeleteElement);
    test("HashArrayGetNext__ShouldIterateThroughAllElements", ::HashArrayGetNext__ShouldIterateThroughAllElements);
}

HashArrayCreate__ShouldCreateEmptyHashArray()
{
    hashArray = HashArrayCreate();
    assert(hashArray.objects.size == 0);
}

HashArrayInsert__ShouldInsertElementIntoHashArray()
{
    hashArray = HashArrayCreate();
    id = HashArrayInsert(hashArray, "element");

    element = HashArrayGet(hashArray, id);

    assert(element == "element");
}

HashArrayDelete__ShouldDeleteElement()
{
    hashArray = HashArrayCreate();
    id = HashArrayInsert(hashArray, "element");
    HashArrayDelete(hashArray, id);

    assert(hashArray.objects[0].isDeleted);
    assert(!isDefined(HashArrayGet(hashArray, 0)));
}

HashArrayGetNext__ShouldIterateThroughAllElements()
{
    hashArray = HashArrayCreate();
    HashArrayInsert(hashArray, "element1");
    HashArrayInsert(hashArray, "element2");
    HashArrayInsert(hashArray, "element3");
    HashArrayDelete(hashArray, 1);

    iterator = HashArrayGetNext(hashArray);
    assert(iterator.element == "element1");
    iterator = HashArrayGetNext(hashArray, iterator.currentIndex);
    assert(iterator.element == "element3");
}

HashArrayGetNext__ShouldIterateThroughAllElements()
{
    hashArray = HashArrayCreate();
    HashArrayInsert(hashArray, "element1");
    HashArrayInsert(hashArray, "element2");
    HashArrayInsert(hashArray, "element3");
    HashArrayInsert(hashArray, "element4");
    HashArrayInsert(hashArray, "element5");
    lastId = HashArrayInsert(hashArray, "element6");
    HashArrayDelete(hashArray, lastId);

    iterations = 0;
    iterator = HashArrayGetNext(hashArray);
    while(isDefined(iterator.element))
    {
        iterations += 1;
        iterator = HashArrayGetNext(hashArray, iterator.currentIndex);
    }

    assert(iterations == 5);
}
