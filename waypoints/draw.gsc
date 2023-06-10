#include blanco\data_structures\edges;
#include blanco\data_structures\nodes;

Main()
{
    level.DRAW_EDGE_DISTNACE_SQUARED = 600 * 600;
    level.DRAW_NODE_DISTNACE_SQUARED = 160 * 160;

    thread initializeDrawingOnPlayerConnect();
}

initializeDrawingOnPlayerConnect()
{
    while (true)
    {
        level waittill("connecting", player);
        player thread playerDrawingLoop();
    }
}

playerDrawingLoop()
{
    self ClearPrintsAndLines();

    while (isDefined(self))
    {
        self drawNodesAndEdges();
        wait 0.05;
    }
}

drawNodesAndEdges()
{
    searchDistance = level.DRAW_EDGE_DISTNACE_SQUARED;
    searchOrigin = self.origin;

    nodes = NodesGetElementsInSquaredDistance(level.nodes, searchOrigin, searchDistance);
    for (i = 0; i < nodes.size; i += 1)
    {
        node = nodes[i];

        color = (1, 1, 1);
        if (isDefined(self.targetedNode) && self.targetedNode == node.uid)
            color = (0, 1, 0.5);

        dist = distanceSquared(searchOrigin, node.origin);
        if (dist < level.DRAW_NODE_DISTNACE_SQUARED)
            print3d(node.origin + (0, 0, 2), i, color, 1, 0.3, 1);

        edges = EdgesGetFrom(level.edges, node.uid);
        for (j = 0; j < edges.size; j += 1)
        {
            if (edges[j].to < node.uid)
                continue;

            otherNode = NodesGetElement(level.nodes, edges[j].to);
            otherEdge = EdgesGet(level.edges, otherNode.uid, node.uid);
            midOrigin = calculateMidOrigin(node.origin, otherNode.origin);

            line(node.origin, midOrigin, getColorForType(edges[j].type), false, 1);
            line(otherNode.origin, midOrigin, getColorForType(otherEdge.type), false, 1);
        }
    }

    for (i = 0; i < self.lines.size; i += 1)
        line(self.lines[i].start, self.lines[i].end, self.lines[i].color, false, 1);

    for (i = 0; i < self.prints.size; i += 1)
        print3d(self.prints[i].origin, self.prints[i].text, self.prints[i].color, 1, 0.3, 1);
}

ClearPrintsAndLines()
{
    self.lines = [];
    self.prints = [];
}

AddLine(start, end, color)
{
    aLine = spawnStruct();
    aLine.start = start;
    aLine.end = end;
    aLine.color = color;

    n = self.lines.size;
    self.lines[n] = aLine;
}

AddPrint(origin, text, color)
{
    aPrint = spawnStruct();
    aPrint.origin = origin;
    aPrint.text = text;
    aPrint.color = color;

    n = self.prints.size;
    self.prints[n] = aPrint;
}

calculateMidOrigin(firstOrigin, secondOrigin)
{
    x = firstOrigin[0] - (firstOrigin[0] - secondOrigin[0]) / 2;
    y = firstOrigin[1] - (firstOrigin[1] - secondOrigin[1]) / 2;
    z = firstOrigin[2] - (firstOrigin[2] - secondOrigin[2]) / 2;
    return (x, y, z);
}

getColorForType(type)
{
    return (0.9, 0.7, 0.6);
}
