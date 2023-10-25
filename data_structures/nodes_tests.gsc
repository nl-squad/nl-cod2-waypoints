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
    test("NodesGetClosestElementInSquareDistance_ShouldReturnClosestNode", ::NodesGetClosestElementInSquareDistance_ShouldReturnClosestNode);
}

NodesCreate__ShouldCreateEmptyNodes()
{
    nodes = NodesCreate(100);
    assert(nodes.nextUid == 1);
    assert(nodes.elements.size == 0);
    assert(nodes.chunks.size == 0);
}

NodesInsert__ShouldInsertElementIntoNodes()
{
    nodes = NodesCreate(100);
    insertedNode = NodesInsert(nodes, (200, 300, 400));
    node = NodesGet(insertedNode.uid);
    
    assert(insertedNode.uid == "1");
    assert(node.uid == "1");
}

NodesDelete__ShouldStillMakeItPossibleToGetAllElements()
{
    nodes = NodesCreate(100);
    insertedNode1 = NodesInsert(nodes, (200, 300, 400));
    insertedNode2 = NodesInsert(nodes, (100, 300, 400));
    insertedNode3 = NodesInsert(nodes, (300, 300, 400));

    NodesDelete(nodes, insertedNode1.uid);

    assert(edges.elements.size == 2);
    assert(edges.elements[0].uid == id2);
    assert(edges.elements[1].uid == id3);
}

NodesDeleteAndInsert__ShouldNotChangeIDsOfOtherElements()
{
    nodes = NodesCreate(100);
    insertedNode1 = NodesInsert(nodes, (200, 300, 400));
    id2 = NodesInsert(nodes, (300, 400, 500));

    NodesDelete(nodes, insertedNode1.uid);
    
    assert(NodesGetElement(nodes, insertedNode2.uid).origin == (300, 400, 500));

    insertedNode3 = NodesInsert(nodes, (500, 600, 700));

    assert(insertedNode3.uid != insertedNode1.uid);
    assert(NodesGetElement(nodes, insertedNode3.uid).origin == (500, 600, 700));
}

NodesGetElementsInSquaredDistance__ShouldReturnElementsInGivenSquaredDistance()
{
    nodes = NodesCreate(100);
    insertedNode1 = NodesInsert(nodes, (200, 300, 400));
    insertedNode2 = NodesInsert(nodes, (300, 400, 500));
    
    elements = NodesGetElementsInSquaredDistance(nodes, (250, 350, 450), 20000);

    assert(elements.size == 2);
    assert(isDefined(NodesGetElement(nodes, insertedNode1.uid)));
    assert(isDefined(NodesGetElement(nodes, insertedNode2.uid)));
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

NodesGetClosestElementInSquareDistance_ShouldReturnClosestNode()
{
    nodes = NodesCreate(100);

    NodesInsert(nodes, (30, 20, 30));
    NodesInsert(nodes, (0, 0, 0));
    NodesInsert(nodes, (-100, -100, 100)); // UID=3
    NodesInsert(nodes, (-104, -104, 101));
    NodesInsert(nodes, (-105, -104, 101));
    NodesInsert(nodes, (-105, -103, 101));
    NodesInsert(nodes, (30, 20, 30));

    node = NodesGetClosestElementInSquareDistance(nodes, (-100, -100, 100), 16 * 16, "3");

    assert(node.uid == "4");
}
