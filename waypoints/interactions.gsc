#include blanco\utils;
#include blanco\data_structures\edges;
#include blanco\data_structures\nodes;

Main()
{
    level.SELECT_NODE_SQUARED_DISTANCE = 16 * 16;

    thread initializeInteractionsOnPlayerConnect();
}

initializeInteractionsOnPlayerConnect()
{
    while (true)
    {
        level waittill("connecting", player);
        player thread playerInteractionsLoop();
    }
}

playerInteractionsLoop()
{
    while (isDefined(self))
    {
        origin = self getTargetOrigin();
        node = self getNodeInSelectRange(origin);

        self.targetedNode = undefined;
        if (isDefined(node))
            self.targetedNode = node.uid;

        if (self useButtonPressed() && !isDefined(node))
        {
            insertNodeInteraction();

            while (self useButtonPressed())
                wait 0.05;
        }

        if (self useButtonPressed() && isDefined(node))
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
            debugNodeInteraction(node);

            while (self meleeButtonPressed())
                wait 0.05;
        }

        wait 0.05;
    }
}

getTargetOrigin()
{
    startOrigin = self.origin + (0, 0, 60);
    forward = anglesToForward(self getPlayerAngles());
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

insertNodeInteraction()
{
    NodesInsert(level.nodes, self getTargetOrigin());
}

removeNodeInteraction(node)
{
    NodesDelete(level.nodes, node.uid);
}

startDrawingEdgeInteraction(node)
{
    self.drawEdgeStartingNode = node;
}

endDrawingEdgeInteraction(node)
{
    if (!isDefined(node))
    {
        self.drawEdgeStartingNode = undefined;
        return;
    }

    if (node.uid == self.drawEdgeStartingNode.uid)
        self iPrintln("^1Can't add edge from node to the same node");

    weight = distanceSquared(self.drawEdgeStartingNode.origin, node.orgin);
    EdgesInsert(level.edges, self.drawEdgeStartingNode.uid, node.uid, weight, level.EDGE_STAND);
    self.drawEdgeStartingNode = undefined;
}

debugNodeInteraction(node)
{
    blanco\waypoints\draw::ClearPrintsAndLines();
    blanco\waypoints\generator::discoverFromNode(node.uid, true);
}