#include blanco\utils;

Main()
{
    level.SELECT_NODE_SQUARED_DISTANCE = 16 * 16; // TODO

    while (true)
    {
        level waittill("connecting", player);
        player thread playerDrawingLoop();
    }
}

playerInteractionsLoop()
{
    while (isDefined(self))
    {
        origin = self getTargetOrigin();
        node = self getNodeInSelectRange(origin);
        edge = self getEdgeInSelectRange(origin);

        if (isDefined(node))
            self.targetedNode = node.uid;

        if (self useButtonPressed() && !isDefined(node))
        {
            insertNodeInteraction();

            while (self useButtonPressed())
                wait 0.05;
        }

        if (self useButtonPress() && isDefined(node))
        {
            startDrawingEdgeInteraction();

            while (self useButtonPressed(node))
                wait 0.05;

            origin = self getTargetOrigin();
            node = self getNodeInSelectRange(origin);
            endDrawingEdgeInteraction();
        }

        if (self meleeButtonPressed() && isDefined(node))
        {
            removeNodeInteraction(node);

            while (self meleeButtonPressed())
                wait 0.05;
        }

        if (self meleeButtonPressed() && isDefined(edge))
        {
            removeEdgeInteraction(node);

            while (self meleeButtonPressed())
                wait 0.05;
        }

        wait 0.05;
    }
}

getTargetOrigin()
{
    startOrigin = self.origin + (0, 0, 60);
    forward = anglesToForward(self getplayerangles());
    forward = maps\mp\_utility::vectorScale(forward, 100000);
    endOrigin = startOrigin + forward;
    trace = bulletTrace(startOrigin, endOrigin, false, self);

    if (trace["fraction"] <= 1 || trace["surfacetype"] == "default")
        endOrigin = trace["position"];

    return endOrigin;
}

getNodeInSelectRange(origin)
{
    nodes = NodesGetElementsInSquaredDistance(level.nodes, origin, level.SELECT_NODE_SQUARED_DISTANCE);

    if (nodes.size > 0)
        return nodes[0];
}

getEdgeInSelectRange(origin)
{
    closestEdge = undefined;
    closestEdgeDistance = -1;

    nodes = NodesGetElementsInSquaredDistance(level.nodes, origin, level.GRID_SIZE * level.GRID_SIZE);
    for (i = 0; i < nodes.size; i += 1)
    {
        node = nodes[i];
        edges = EdgesGetFrom(level.edges, node.uid);

        for (j = 0; j < edges.size; j += 1)
        {
            otherNode = NodesGetElement(nodes, edges[j].to);
            midOrigin = waypoints\draw::calculateMidOrigin(node.origin, otherNode.origin);
            dist = distanceSquared(midOrigin, origin);

            if (!isDefined(closestEdge) || dist < closestEdgeDistance)
            {
                closestEdge = edges[j];
                closestEdgeDistance = dist;
            }
        }
    }

    return closestEdge;
}

insertNodeInteraction()
{
    node = spawnStruct();
    node.origin = self getTargetOrigin();

    NodesInsert(level.nodes, node);
}

removeNodeInteraction(node)
{
    NodesDelete(level.nodes, node.uid);
}

removeEdgeInteraction(edge)
{
    EdgesDelete(level.edges, edge.from, edge.to);
}

startDrawingEdgeInteraction(node)
{
    self.drawEdgeStartingNode = node;
}

endDrawingEdgeInteraction(node)
{
    if (node.uid == self.drawEdgeStartingNode.uid)
        self iPrintln("^1Can't add edge from node to the same node");

    weight = distanceSquared(self.drawEdgeStartingNode.origin, node.orgin);
    EdgesInsert(level.edges, self.drawEdgeStartingNode.uid, node.uid, weight, level.EDGE_STAND);
}
