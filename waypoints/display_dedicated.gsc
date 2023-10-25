Main()
{
    level.DISPLAYING_NODE_SQUARED_DISTANCE = 200 * 200;
    level.DISPLAYING_EDGE_SQUARED_DISTANCE = 200 * 200;

    level.NODE_FX = loadFx("fx/blanco_energie_sky.efx");

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
            nodes = NodesGetElementsInSquaredDistance(level.nodes, self.origin, level.DISPLAYING_NODE_SQUARED_DISTANCE);
            for (i = 0; i < nodes.size; i += 1)
                if (!isDefined(displayed[nodes[i].uid]))
                {
                    displayed[nodes[i].uid] = true;
                    playFx(level.NODE_FX, nodes[i].origin);
                }

            edges = EdgesGetElementsInSquaredDistance(level.edges, self.origin, level.DISPLAYING_EDGE_SQUARED_DISTANCE);
            for (i = 0; i < edges.size; i += 1)
                if (!isDefined(displayed[edges[i].fromUid + "_" + edges[i].toUid]))
                {
                    displayed[edges[i].fromUid + "_" + edges[i].toUid] = true;
                    playFx(GetFxForEdgeType(edges[i].type), edges[i].selectOrigin);
                }

            // TODO: Implement displaying selected waypoints
        }

        wait 1;
    }
}
