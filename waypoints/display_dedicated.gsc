#include blanco\data_structures\edges;
#include blanco\data_structures\nodes;

Main()
{
    level.DISPLAYING_NODE_SQUARED_DISTANCE = 200 * 200;
    level.DISPLAYING_EDGE_SQUARED_DISTANCE = 200 * 200;

    level.NODE_FX = loadFx("fx/blanco_energie_sky.efx");
    level.TARGET_FX = loadFx("fx/blanco_energie_pink.efx");

    thread initializeDisplaying();
}

initializeDisplaying()
{
    while (true)
    {
        displayed = [];

		players = getEntArray("player", "classname");
        for (j = 0; j < players.size; j += 1)
        {
            nodes = NodesGetElementsInSquaredDistance(level.nodes, players[j].origin, level.DISPLAYING_NODE_SQUARED_DISTANCE);
            for (i = 0; i < nodes.size; i += 1)
                if (!isDefined(displayed[nodes[i].uid]))
                {
                    displayed[nodes[i].uid] = true;
                    if (isTargetedNode(nodes[i]))
                        playFx(level.TARGET_FX, nodes[i].origin);
                    else
                        playFx(level.NODE_FX, nodes[i].origin);
                }

            edges = EdgesGetElementsInSquaredDistance(level.edges, players[j].origin, level.DISPLAYING_EDGE_SQUARED_DISTANCE);
            for (i = 0; i < edges.size; i += 1)
                if (!isDefined(displayed[edges[i].fromUid + "_" + edges[i].toUid]))
                {
                    displayed[edges[i].fromUid + "_" + edges[i].toUid] = true;

                    if (isTargetedEdge(edges[i]))
                        playFx(level.TARGET_FX, edges[i].selectOrigin);
                    else
                        playFx(blanco\waypoints\edge_types::GetFxForEdgeType(edges[i].type), edges[i].selectOrigin);
                }
        }

        wait 1;
    }
}

isTargetedNode(node)
{
    players = getEntArray("player", "classname");
    for (i = 0; i < players.size; i += 1)
        if (isDefined(players[i].targetedNode) && players[i].targetedNode.uid == node.uid)
            return true;

    return false;
}

isTargetedEdge(edge)
{
    players = getEntArray("player", "classname");
    for (i = 0; i < players.size; i += 1)
        if (isDefined(players[i].targetedEdge) && players[i].targetedEdge.fromUid == edge.fromUid && players[i].targetedEdge.toUid == edge.toUid)
            return true;

    return false;
}