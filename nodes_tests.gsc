#include blanco\tests;
#include blanco\nodes;

Main()
{
    test("NodesCreate__ShouldCreateEmptyNodes", ::NodesCreate__ShouldCreateEmptyNodes);
    test("NodesInsert__ShouldInsertElementIntoNodes", ::NodesInsert__ShouldInsertElementIntoNodes);
    test("NodesGet__ShouldReturnInsertedElement", ::NodesGet__ShouldReturnInsertedElement);
    test("NodesDelete__ShouldRemoveElementFromNodes", ::NodesDelete__ShouldRemoveElementFromNodes);
}

NodesCreate__ShouldCreateEmptyNodes()
{
    nodes = NodesCreate();
    assert(nodes.elements.size == 0);
}

NodesInsert__ShouldInsertElementIntoNodes()
{
    nodes = NodesCreate();
    element = spawnStruct();
    element.value = 42;
    index = NodesInsert(nodes, element);

    assert(nodes.elements.size == 1);
    assert(nodes.elements[index] == element);
}

NodesGet__ShouldReturnInsertedElement()
{
    nodes = NodesCreate();
    element = spawnStruct();
    element.value = 42;
    index = NodesInsert(nodes, element);

    retrievedElement = NodesGet(nodes, index);
    assert(retrievedElement == element);
}

NodesDelete__ShouldRemoveElementFromNodes()
{
    nodes = NodesCreate();
    element = spawnStruct();
    element.value = 42;
    index = NodesInsert(nodes, element);

    NodesDelete(nodes, index);
    assert(nodes.elements.size == 0);
}
