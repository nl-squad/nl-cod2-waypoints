#include blanco\tests;
#include blanco\data_structures\nodes;

Main()
{
    test("NodesCreate__ShouldCreateEmptyNodes", ::NodesCreate__ShouldCreateEmptyNodes);
    test("NodesGetAll__ShouldReturnAllNodes", ::NodesGetAll__ShouldReturnAllNodes);
    test("NodesInsert__ShouldInsertElementIntoNodes", ::NodesInsert__ShouldInsertElementIntoNodes);
    test("NodesDeleteAndInsert__ShouldNotChangeIDsOfOtherElements", ::NodesDeleteAndInsert__ShouldNotChangeIDsOfOtherElements);
    test("NodesGetElementsInSquaredDistance__ShouldReturnElementsInGivenSquaredDistance", ::NodesGetElementsInSquaredDistance__ShouldReturnElementsInGivenSquaredDistance);
    test("NodesGetElementsInSquaredDistance__ShouldNotReturnElementsOutOfGivenSquaredDistance", ::NodesGetElementsInSquaredDistance__ShouldNotReturnElementsOutOfGivenSquaredDistance);
    test("NodesGetElementsInSquaredDistance__ShouldNotReturnElementsOnBorderOfNodes", ::NodesGetElementsInSquaredDistance__ShouldNotReturnElementsOnBorderOfNodes);
    test("NodesGetClosestElementInSquareDistance_ShouldReturnClosestNode", ::NodesGetClosestElementInSquareDistance_ShouldReturnClosestNode);
    test("NodesLoad__ShouldAppendNewNodes", ::NodesLoad__ShouldAppendNewNodes);
}

NodesCreate__ShouldCreateEmptyNodes()
{
    nodes = NodesCreate(100);
    assert(nodes.nextUid == 1);
    assert(nodes.elements.size == 0);
    assert(nodes.chunks.size == 0);
}

NodesGetAll__ShouldReturnAllNodes()
{
    nodes = NodesCreate(100);

    insertedNode1 = NodesInsert(nodes, (30, 20, 30));
    insertedNode2 = NodesInsert(nodes, (0, 0, 0));
    insertedNode3 = NodesInsert(nodes, (-100, -100, 100));
    insertedNode4 = NodesInsert(nodes, (30, 20, 30));

    assert(NodesGetAll(nodes).size == 4);

    NodesDelete(nodes, insertedNode1.uid);

    assert(NodesGetAll(nodes).size == 3);

    NodesDelete(nodes, insertedNode3.uid);

    assert(NodesGetAll(nodes).size == 2);

    NodesDelete(nodes, insertedNode4.uid);

    assert(NodesGetAll(nodes).size == 1);
}

NodesInsert__ShouldInsertElementIntoNodes()
{
    nodes = NodesCreate(100);
    insertedNode = NodesInsert(nodes, (200, 300, 400));
    node = NodesGet(nodes, insertedNode.uid);
    
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

    assert(NodesGetAll(nodes).size == 2);
    assert(NodesGet(insertedNode2.uid).uid == insertedNode2.uid);
    assert(NodesGetAll(nodes)[1].uid == insertedNode3.uid);
}

NodesDeleteAndInsert__ShouldNotChangeIDsOfOtherElements()
{
    nodes = NodesCreate(100);
    insertedNode1 = NodesInsert(nodes, (200, 300, 400));
    insertedNode2 = NodesInsert(nodes, (300, 400, 500));

    NodesDelete(nodes, insertedNode1.uid);
    
    assert(NodesGet(nodes, insertedNode2.uid).origin == (300, 400, 500));

    insertedNode3 = NodesInsert(nodes, (500, 600, 700));

    assert(insertedNode3.uid != insertedNode1.uid);
    assert(NodesGet(nodes, insertedNode3.uid).origin == (500, 600, 700));
}

NodesGetElementsInSquaredDistance__ShouldReturnElementsInGivenSquaredDistance()
{
    nodes = NodesCreate(100);
    insertedNode1 = NodesInsert(nodes, (200, 300, 400));
    insertedNode2 = NodesInsert(nodes, (300, 400, 500));
    
    elements = NodesGetElementsInSquaredDistance(nodes, (250, 350, 450), 20000);

    assert(elements.size == 2);
    assert(isDefined(NodesGet(nodes, insertedNode1.uid)));
    assert(isDefined(NodesGet(nodes, insertedNode2.uid)));
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

NodesLoad__ShouldAppendNewNodes()
{
    nodes = NodesCreate(100);

    NodesLoad(nodes, "10", (10, 20, 30));
    NodesLoad(nodes, "11", (11, 20, 31));

    assert(nodes.nextUid == 12);
}
