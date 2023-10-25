#include blanco\tests;
#include blanco\data_structures\nodes;

Main()
{
    test("NodesCreate__ShouldCreateEmptyNodes", ::NodesCreate__ShouldCreateEmptyNodes);
    test("NodesInsert__ShouldInsertElementIntoNodes", ::NodesInsert__ShouldInsertElementIntoNodes);
    test("NodesDeleteAndInsert__ShouldNotChangeIDsOfOtherElements", ::NodesDeleteAndInsert__ShouldNotChangeIDsOfOtherElements);
    test("NodesGetElementsInSquaredDistance__ShouldReturnElementsInGivenSquaredDistance", ::NodesGetElementsInSquaredDistance__ShouldReturnElementsInGivenSquaredDistance);
    test("NodesGetElementsInSquaredDistance__ShouldNotReturnElementsOutOfGivenSquaredDistance", ::NodesGetElementsInSquaredDistance__ShouldNotReturnElementsOutOfGivenSquaredDistance);
    test("NodesGetElementsInSquaredDistance__ShouldNotReturnElementsOnBorderOfNodes", ::NodesGetElementsInSquaredDistance__ShouldNotReturnElementsOnBorderOfNodes);
}

NodesCreate__ShouldCreateEmptyNodes()
{
    nodes = NodesCreate(100);
    assert(nodes.nextUid == 1);
    assert(nodes.elements.size == 0);
    assert(nodes.dictionary.size == 0);
}

NodesInsert__ShouldInsertElementIntoNodes()
{
    nodes = NodesCreate(100);
    uid = NodesInsert(nodes, (200, 300, 400));

    assert(isDefined(NodesGetElement(nodes, uid)));
}

NodesDelete__ShouldStillMakeItPossibleToGetAllElements()
{
    nodes = NodesCreate(100);
    id1 = NodesInsert(nodes, (200, 300, 400));
    id2 = NodesInsert(nodes, (100, 300, 400));
    id3 = NodesInsert(nodes, (300, 300, 400));

    NodesDelete(nodes, id1);

    assert(edges.elements.size == 2);
    assert(edges.elements[0].uid == id2);
    assert(edges.elements[1].uid == id3);
}

NodesDeleteAndInsert__ShouldNotChangeIDsOfOtherElements()
{
    nodes = NodesCreate(100);
    id1 = NodesInsert(nodes, (200, 300, 400));
    id2 = NodesInsert(nodes, (300, 400, 500));

    NodesDelete(nodes, id1);
    
    assert(NodesGetElement(nodes, id2).origin == (300, 400, 500));

    id3 = NodesInsert(nodes, (500, 600, 700));

    assert(id3 != id1);
    assert(NodesGetElement(nodes, id3).origin == (500, 600, 700));
}

NodesGetElementsInSquaredDistance__ShouldReturnElementsInGivenSquaredDistance()
{
    nodes = NodesCreate(100);
    uid1 = NodesInsert(nodes, (200, 300, 400));
    uid2 = NodesInsert(nodes, (300, 400, 500));
    
    elements = NodesGetElementsInSquaredDistance(nodes, (250, 350, 450), 20000);

    assert(elements.size == 2);
    assert(isDefined(NodesGetElement(nodes, uid1)));
    assert(isDefined(NodesGetElement(nodes, uid2)));
}

NodesGetElementsInSquaredDistance__ShouldNotReturnElementsOutOfGivenSquaredDistance()
{
    nodes = NodesCreate(10);
    NodesInsert(nodes, (5, 0, 0));
    NodesInsert(nodes, (5, 0, 1));
    NodesInsert(nodes, (5, 10, 0));
    NodesInsert(nodes, (5, 0, 10));
    NodesInsert(nodes, (5, 1, 10));
    NodesInsert(nodes, (15, 0, 0));
    NodesInsert(nodes, (-5, 0, 0));
    NodesInsert(nodes, (-5.1, 0, 0));

    elements = NodesGetElementsInSquaredDistance(nodes, (5, 0, 0), 100);

    assert(elements.size == 6);
}

NodesGetElementsInSquaredDistance__ShouldNotReturnElementsOnBorderOfNodes()
{
    nodes = NodesCreate(10);
    NodesInsert(nodes, (10, 20, 30));
    NodesInsert(nodes, (30, 20, 30));
    NodesInsert(nodes, (0, 0, 0));

    elements = NodesGetElementsInSquaredDistance(nodes, (20, 20, 30), 100);

    assert(elements.size == 2);
}
