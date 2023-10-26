#include blanco\tests;
#include blanco\data_structures\edges;

Main()
{
    test("EdgesCreate__ShouldCreateEmptyEdges", ::EdgesCreate__ShouldCreateEmptyEdges);
    test("EdgesInsert__ShouldInsertEdgeIntoEdges", ::EdgesInsert__ShouldInsertEdgeIntoEdges);
    test("EdgesGetAll__ShouldReturnAllEdges", ::EdgesGetAll__ShouldReturnAllEdges);
    test("EdgesGetFrom__ShouldReturnInsertedEdgesFrom", ::EdgesGetFrom__ShouldReturnInsertedEdgesFrom);
    test("EdgesGetFrom__ShouldReturnInsertedEdgesTo", ::EdgesGetFrom__ShouldReturnInsertedEdgesTo);
    test("EdgesDelete__ShouldRemoveEdgeFromEdges", ::EdgesDelete__ShouldRemoveEdgeFromEdges);
    test("EdgesExists__ShouldCheckIfEdgeExists", ::EdgesExists__ShouldCheckIfEdgeExists);
    test("EdgesCalculateSelectOrigins_ShouldCalculateToAndReverse", ::EdgesCalculateSelectOrigins_ShouldCalculateToAndReverse);
    test("EdgesInsert_ShouldAssignCorrectChunks", ::EdgesInsert_ShouldAssignCorrectChunks);
    test("EdgesGetElementsInSquaredDistance_ShouldReturnEveryEdgeInDistance", ::EdgesGetElementsInSquaredDistance_ShouldReturnEveryEdgeInDistance);
    test("EdgesGetClosestElementInSquareDistance_ShouldFindClosestEdge", ::EdgesGetClosestElementInSquareDistance_ShouldFindClosestEdge);
}

EdgesCreate__ShouldCreateEmptyEdges()
{
    edges = EdgesCreate(100);
    assert(edges.elements.size == 0);
}

EdgesInsert__ShouldInsertEdgeIntoEdges()
{
    edges = EdgesCreate(100);
    insertedEdge = EdgesInsert(edges, "0", "1", 1, "edgeType", (10, 10, 20));
    edge = EdgesGet(edges, "0", "1");

    assert(isDefined(edges.elements["0_1"]));

    assert(insertedEdge.fromUid == edge.fromUid);
    assert(insertedEdge.toUid == edge.toUid);

    assert(edge.fromUid == "0");
    assert(edge.toUid == "1");
    assert(edge.weight == 1);
    assert(edge.type == "edgeType");
    assert(edge.selectOrigin[0] == 10);
    assert(edge.selectOrigin[1] == 10);
    assert(edge.selectOrigin[2] == 20);
}

EdgesGetAll__ShouldReturnAllEdges()
{
    edges = EdgesCreate(100);
    EdgesInsert(edges, "0", "11", 11, "type", (0, 0, 0));
    EdgesInsert(edges, "0", "12", 12, "type", (0, 0, 0));
    EdgesInsert(edges, "12", "11", 21, "type", (0, 0, 0));
    EdgesInsert(edges, "0", "1", 1, "type", (1, 2, 3));
    EdgesInsert(edges, "3", "33", 1, "type", (95, 95, 0));

    assert(EdgesGetAll(edges).size == 5);

    EdgesDelete(edges, "0", "1");

    assert(EdgesGetAll(edges).size == 4);

    EdgesDelete(edges, "3", "33");

    assert(EdgesGetAll(edges).size == 3);
}

EdgesGetFrom__ShouldReturnInsertedEdgesFrom()
{
    edges = EdgesCreate(100);
    EdgesInsert(edges, "0", "1", 2, "type", (0, 0, 0));

    edgesFrom = EdgesGetFrom(edges, "0");
    assert(edgesFrom.size == 1);
    assert(edgesFrom[0].fromUid == "0");
    assert(edgesFrom[0].toUid == "1");
    assert(edgesFrom[0].weight == 2);
}

EdgesGetFrom__ShouldReturnInsertedEdgesTo()
{
    edges = EdgesCreate(100);
    EdgesInsert(edges, "0", "12", 3, "type", (0, 0, 0));

    edgesTo = EdgesGetTo(edges, "12");
    assert(edgesTo.size == 1);
    assert(edgesTo[0].fromUid == "0");
    assert(edgesTo[0].toUid == "12");
    assert(edgesTo[0].weight == 3);
}

EdgesDelete__ShouldRemoveEdgeFromEdges()
{
    edges = EdgesCreate(100);
    EdgesInsert(edges, "0", "11", 11, "type", (0, 0, 0));
    EdgesInsert(edges, "0", "12", 12, "type", (0, 0, 0));
    EdgesInsert(edges, "12", "11", 21, "type", (0, 0, 0));

    EdgesDelete(edges, "0", "12");

    edgesTo11 = EdgesGetTo(edges, "11");
    edgesTo12 = EdgesGetTo(edges, "12");
    edgesTo0 = EdgesGetTo(edges, "0");
    edgesFrom11 = EdgesGetFrom(edges, "11");
    edgesFrom12 = EdgesGetFrom(edges, "12");
    edgesFrom0 = EdgesGetFrom(edges, "0");

    assert(edgesTo11.size == 2);
    assert(edgesTo12.size == 0);
    assert(edgesTo0.size == 0);
    assert(edgesFrom11.size == 0);
    assert(edgesFrom12.size == 1);
    assert(edgesFrom0.size == 1);
}

EdgesExists__ShouldCheckIfEdgeExists()
{
    edges = EdgesCreate(100);
    EdgesInsert(edges, "3", "7", 1, "type", (0, 0, 0));

    assert(EdgesExists(edges, "3", "7"));
    assert(!EdgesExists(edges, "7", "3"));
}

EdgesCalculateSelectOrigins_ShouldCalculateToAndReverse()
{
    originA = (10, 10, 13);
    originB = (10, 210, 13);

    selectOrigins = EdgesCalculateSelectOrigins(originA, originB);

    assert(selectOrigins.forward[0] == 10);
    assert(selectOrigins.forward[1] == 110 - level.EDGE_SELECTOR_OFFSET);
    assert(selectOrigins.forward[2] == 13);
    assert(selectOrigins.reverse[0] == 10);
    assert(selectOrigins.reverse[1] == 110 + level.EDGE_SELECTOR_OFFSET);
    assert(selectOrigins.reverse[2] == 13);
}

EdgesInsert_ShouldAssignCorrectChunks()
{
    edges = EdgesCreate(100);

    EdgesInsert(edges, "2", "3", 1, "type", (0, 0, 0));
    EdgesInsert(edges, "2", "4", 1, "type", (0, 50, 50));
    EdgesInsert(edges, "2", "6", 1, "type", (0, 100, 50));

    assert(edges.chunks["0"]["0"]["0"].size == 2);
    assert(edges.chunks["0"]["1"]["0"].size == 1);

    EdgesDelete(edges, "2", "4");

    assert(edges.chunks["0"]["0"]["0"].size == 1);
    assert(edges.chunks["0"]["1"]["0"].size == 1);
}

EdgesGetElementsInSquaredDistance_ShouldReturnEveryEdgeInDistance()
{
    edges = EdgesCreate(100);

    EdgesInsert(edges, "2", "3", 1, "type", (0, 0, 0));
    EdgesInsert(edges, "2", "4", 1, "type", (0, 50, 50));
    EdgesInsert(edges, "2", "6", 1, "type", (0, 100, 50));
    EdgesInsert(edges, "3", "8", 1, "type", (0, 100, 101));
    EdgesInsert(edges, "13", "8", 1, "type", (0, 101, 0));
    EdgesInsert(edges, "3", "18", 1, "type", (0, -100, 0));
    EdgesInsert(edges, "223", "8", 1, "type", (-101, 0, 0));

    foundEdges = EdgesGetElementsInSquaredDistance(edges, (0, 0, 0), 100 * 100);

    assert(foundEdges.size == 3);
}

EdgesGetClosestElementInSquareDistance_ShouldFindClosestEdge()
{
    edges = EdgesCreate(100);

    EdgesInsert(edges, "0", "1", 1, "type", (1, 2, 3));
    EdgesInsert(edges, "3", "33", 1, "type", (95, 95, 0));
    EdgesInsert(edges, "7", "11", 1, "type", (100, 100, 140));
    EdgesInsert(edges, "33", "3", 1, "type", (106, 106, 0));
    EdgesInsert(edges, "10", "1", 1, "type", (100, 0, 0));

    edge = EdgesGetClosestElementInSquareDistance(edges, (100, 100, 0), 16 * 16);

    assert(edge.fromUid == "3");
    assert(edge.toUid == "33");
}