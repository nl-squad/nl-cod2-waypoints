#include blanco\tests;
#include blanco\data_structures\nodes;
#include blanco\data_structures\edges;

Main()
{
    test("Edges_ShouldReferenceNodeUids", ::Edges_ShouldReferenceNodeUids);
}

Edges_ShouldReferenceNodeUids()
{
    nodes = NodesCreate(100);
    edges = EdgesCreate(100);

    insertedNode1 = NodesInsert(nodes, (0, 0, 0));
    insertedNode2 = NodesInsert(nodes, (0, 100, 0));

    weight = EdgesCalculateDistance(insertedNode1.origin, insertedNode2.origin);
    selectOrigins = EdgesCalculateSelectOrigins(insertedNode1.origin, insertedNode2.origin);
    EdgesInsert(edges, insertedNode1.uid, insertedNode2.uid, weight, 1, selectOrigins.forward);

    edgesFromUid1 = EdgesGetFrom(edges, insertedNode1.uid);
    assert(edgesFromUid1.size == 1);

    edgesFromUid2 = EdgesGetFrom(edges, insertedNode2.uid);
    assert(edgesFromUid2.size == 0);

    firstEdge = edgesFromUid1[0];
    otherNode = NodesGet(nodes, firstEdge.toUid);

    assert(isDefined(otherNode));
    assert(isDefined(otherNode.origin));

    edgeFromOtherNode = EdgesGet(edges, otherNode.uid, insertedNode1.uid);
    assert(!isDefined(edgeFromOtherNode));
    
    edgesFromInsertedNode = EdgesGet(edges, insertedNode1.uid, otherNode.uid);
    assert(isDefined(edgesFromInsertedNode));
}
