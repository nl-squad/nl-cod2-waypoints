Main()
{
    level.DISPLAYING_NODE_SQUARED_DISTANCE = 200 * 200;
    level.DISPLAYING_EDGE_SQUARED_DISTANCE = 200 * 200;

    level.TARGET_COLOR = (253 / 255, 121 / 255, 168 / 255);

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
        {
            color = (1, 1, 1);
            if (isTargetedNode(nodes[i]))
                color = level.TARGET_COLOR;

            print3d(node.origin, node.uid, color, 1, 0.3, 1);
        }
        
        edges = EdgesGetElementsInSquaredDistance(level.edges, self.origin, level.DISPLAYING_EDGE_SQUARED_DISTANCE);
        for (i = 0; i < edges.size; i += 1)
        {
            color = GetColorForEdgeType(edges[i].type);
            if (isTargetedEdge(edges[i]))
                color = level.TARGET_COLOR;

            startOrigin = NodesGet(level.nodes, edges[i].fromUid);
            line(startOrigin, edges[i].selectOrigin, color, false, 1);
        }

	    waittillframeend;
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
        if (isDefined(players[i].targetedEdge) && players[i].targetedEdge.fromUid == node.uid)
            return true;

    return false;
}