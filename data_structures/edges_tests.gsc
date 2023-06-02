#include blanco\tests;
#include blanco\data_structures\edges;

Main()
{
    test("EdgesCreate__ShouldCreateEmptyEdges", ::EdgesCreate__ShouldCreateEmptyEdges);
    test("EdgesInsert__ShouldInsertEdgeIntoEdges", ::EdgesInsert__ShouldInsertEdgeIntoEdges);
    test("EdgesGetFrom__ShouldReturnInsertedEdges", ::EdgesGetFrom__ShouldReturnInsertedEdges);
    test("EdgesDelete__ShouldRemoveEdgeFromEdges", ::EdgesDelete__ShouldRemoveEdgeFromEdges);
    test("EdgesExists__ShouldCheckIfEdgeExists", ::EdgesExists__ShouldCheckIfEdgeExists);
    test("EdgesIsTwoWay__ShouldCheckIfEdgeIsTwoWay", ::EdgesIsTwoWay__ShouldCheckIfEdgeIsTwoWay);
    test("EdgesGet__ShouldReturnInsertedEdge", ::EdgesGet__ShouldReturnInsertedEdge);
}

EdgesCreate__ShouldCreateEmptyEdges()
{
    edges = EdgesCreate();
    assert(edges.elements.size == 0);
}

EdgesInsert__ShouldInsertEdgeIntoEdges()
{
    edges = EdgesCreate();
    EdgesInsert(edges, 0, 1, 1, "edgeType");

    assert(isDefined(edges.elements["0"]));
    assert(edges.elements["0"].list.size == 1);
    assert(isDefined(edges.elements["0"].dictionary["1"]));
}

EdgesGetFrom__ShouldReturnInsertedEdges()
{
    edges = EdgesCreate();
    EdgesInsert(edges, 0, 1, 1, "edgeType");

    edgeList = EdgesGetFrom(edges, 0);
    assert(edgeList.size == 1);
}

EdgesDelete__ShouldRemoveEdgeFromEdges()
{
    edges = EdgesCreate();
    EdgesInsert(edges, 0, 1, 1, "edgeType");

    EdgesDelete(edges, 0, 1);
    assert(edges.elements["0"].list.size == 0);
    assert(!isDefined(edges.elements["0"].dictionary["1"]));
}

EdgesExists__ShouldCheckIfEdgeExists()
{
    edges = EdgesCreate();
    EdgesInsert(edges, 0, 1, 1, "edgeType");

    assert(EdgesExists(edges, 0, 1));
}

EdgesIsTwoWay__ShouldCheckIfEdgeIsTwoWay()
{
    edges = EdgesCreate();
    EdgesInsert(edges, 0, 1, 1, "edgeType");
    EdgesInsert(edges, 1, 0, 1, "edgeType");

    assert(EdgesIsTwoWay(edges, 0, 1));
}

EdgesGet__ShouldReturnInsertedEdge()
{
    edges = EdgesCreate();
    EdgesInsert(edges, 0, 1, 1, "edgeType");

    edge = EdgesGet(edges, 0, 1);
    assert(edge.weight == 1);
    assert(edge.type == "edgeType");
}
