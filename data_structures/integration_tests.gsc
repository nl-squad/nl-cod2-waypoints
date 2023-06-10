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
    edges = EdgesCreate();

    uid1 = NodesInsert(nodes, (0, 0, 0));
    uid2 = NodesInsert(nodes, (0, 100, 0));
    EdgesInsert(edges, uid1, uid2, 10000, 1);

    edgesFromUid1 = EdgesGetFrom(edges, uid1);
    assert(edgesFromUid1.size == 1);

    edgesFromUid2 = EdgesGetFrom(edges, uid2);
    assert(edgesFromUid2.size == 0);

    firstEdge = edgesFromUid1[0];
    otherNode = NodesGetElement(nodes, firstEdge.to);

    assert(isDefined(otherNode));
    assert(isDefined(otherNode.origin));

    edgesFromOtherNode = EdgesGet(edges, otherNode.uid, uid1);
    assert(edgesFromOtherNode.size == 0);
    
    edgesFromOtherNode = EdgesGet(edges, uid1, otherNode.uid);
    assert(edgesFromOtherNode.size == 1);
}
