#include blanco\utils;

Main()
{
    level.DRAW_EDGE_DISTNACE_SQUARED = 600 * 600;
    level.DRAW_NODE_DISTNACE_SQUARED = 160 * 160;

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
        if (self useButtonPressed())
        {
            origin = self getTargetOrigin();
            nodeIndex = getClosestNodeIndex(origin);
            
            edges = getEdgesFrom(nodeIndex);
            printArray(edges, "edges of " + nodeIndex, ::printEdge);

            while (self useButtonPressed())
                wait 0.05;
        }

        if (self meleeButtonPressed())
        {
            origin = self getTargetOrigin();
            nodeIndex = getClosestNodeIndex(origin);
            clearPrintsAndLines();
            discoverFromNode(nodeIndex, true);
            level.p.debugNode = nodeIndex;
            iPrintln("^5" + level.nodes[nodeIndex].from);

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
