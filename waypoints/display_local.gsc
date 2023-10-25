Main()
{
    level.DISPLAYING_NODE_SQUARED_DISTANCE = 200 * 200;
    level.DISPLAYING_EDGE_SQUARED_DISTANCE = 200 * 200;

    thread initializeDisplaying();
}

initializeDisplaying()
{
    while (true)
    {
        level waittill("connecting", player);
        player thread displayingLoop();
    }
}

displayingLoop()
{
    while (isDefined(self))
    {
        nodes = NodesGetElementsInSquaredDistance(level.nodes, self.origin, level.DISPLAYING_NODE_SQUARED_DISTANCE);
        for (i = 0; i < nodes.size; i += 1)
            print3d(node.origin, node.uid, (1, 1, 1), 1, 0.3, 1);

        edges = EdgesGetElementsInSquaredDistance(level.edges, self.origin, level.DISPLAYING_EDGE_SQUARED_DISTANCE);
        for (i = 0; i < edges.size; i += 1)
        {
            startOrigin = NodesGet(level.nodes, edges[i].fromUid);
            line(startOrigin, edges[i].selectOrigin, GetColorForEdgeType(edges[i].type), false, 1);
        }

	    waittillframeend;

        // TODO: Implement displaying selected waypoints
    }
}