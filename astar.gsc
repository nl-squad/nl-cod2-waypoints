
constructPath(lastNodeIndex, nodeIndex)
{
    path = [];
    path[path.size] = lastNodeIndex;
    path[path.size] = nodeIndex;

    closedListIndex = getClosedListIndex(nodeIndex);
    while (isDefined(closedListIndex))
    {
        nodeIndex = self.closedList[closedListIndex].from;
        if (nodeIndex == -1)
            break;

        path[path.size] = nodeIndex;

        closedListIndex = getClosedListIndex(nodeIndex);
    }

    for (i = 0; i < path.size; i += 1)
        blanco\waypoints::setNodeColor(path[i], (0, 1, .2));

    return path;
}

solve(from, to)
{
    self.openList = [];
    self.closedList = [];
    addToOpenList(from, -1, 0, getHeuristic(from, to));
    
    while (self.openList.size > 0)
    {
        currentNodeIndex = getLowestCostNodeIndex();
        currentNode = getNodeFromOpenList(currentNodeIndex);
        // blanco\waypoints::printArray(self.openList, "openList", ::printOpenListItem);
        iPrintln(currentNode.nodeIndex + " cost=" + currentNode.cost + " heuristic=" + currentNode.heuristic);
        blanco\waypoints::setNodeColor(currentNode.nodeIndex, (0, 0.2, 1));

        if (currentNode.nodeIndex == to)
        {
            return constructPath(currentNode.nodeIndex, currentNode.from);
        }

        removeFromOpenList(currentNode.nodeIndex);
        addToClosedList(currentNode.nodeIndex, currentNode.from, currentNode.cost, currentNode.heuristic);

        neighbours = getNeighborIndicies(currentNode.nodeIndex);
        for (i = 0; i < neighbours.size; i += 1)
        {
            neighbourIndex = neighbours[i];
            cost = currentNode.cost + getCost(currentNode.nodeIndex, neighbourIndex);

            closedListIndex = getClosedListIndex(neighbourIndex);
            if (isDefined(closedListIndex))
            {
                if (self.closedList[closedListIndex].cost > cost)
                { 
                    iPrintln("xshorter path to " + self.closedList[closedListIndex].nodeIndex);
                    self.closedList[closedListIndex].from = currentNode.nodeIndex;
                    self.closedList[closedListIndex].cost = cost;
                }
                continue;
            }

            openListIndex = getOpenListIndex(neighbourIndex);

            if (!isDefined(openListIndex))
            {
                addToOpenList(neighbourIndex, currentNode.nodeIndex, cost, getHeuristic(neighbourIndex, to));
                blanco\waypoints::setNodeColor(neighbourIndex, (.6, .6, .6));
            }
            else if (self.openList[openListIndex].cost > cost)
            {
                iPrintln("shorter path to " + self.openList[openListIndex].nodeIndex);
                self.openList[openListIndex].from = currentNode.nodeIndex;
                self.openList[openListIndex].cost = cost;
            }
        }
    }

    return undefined;
}

addToOpenList(nodeIndex, from, cost, heuristic)
{
    item = spawnStruct();
    item.nodeIndex = nodeIndex;
    item.from = from;
    item.cost = cost;
    item.heuristic = heuristic;
    item.total = cost + heuristic;

    self.openList[self.openList.size] = item;
}

removeFromOpenList(nodeIndex)
{
    openList = [];
    for (i = 0; i < self.openList.size; i += 1)
        if (self.openList[i].nodeIndex != nodeIndex)
            openList[openList.size] = self.openList[i];

    self.openList = openList;
}

printOpenListItem(item)
{
    return "(" + item.nodeIndex + ")";
}

addToClosedList(nodeIndex, from, cost, heuristic)
{
    item = spawnStruct();
    item.nodeIndex = nodeIndex;
    item.from = from;
    item.cost = cost;
    item.heuristic = heuristic;
    item.total = cost + heuristic;

    self.closedList[self.closedList.size] = item;
}

getLowestCostNodeIndex()
{
    best = 0;
    for (i = 1; i < self.openList.size; i += 1)
        if (self.openList[i].total < self.openList[best].total)
            best = i;

    return best;
}

getNodeFromOpenList(nodeIndex)
{
    return self.openList[nodeIndex];
}

getNeighborIndicies(nodeIndex)
{
    neighbours = [];
    edges = blanco\waypoints::getEdgesFrom(nodeIndex);
    for (i = 0; i < edges.size; i += 1)
        neighbours[neighbours.size] = edges[i].to;

    return neighbours;
}

getOpenListIndex(nodeIndex)
{
    for (i = 0; i < self.openList.size; i += 1)
        if (self.openList[i].nodeIndex == nodeIndex)
            return i;

    return undefined;
}

getClosedListIndex(nodeIndex)
{
    for (i = 0; i < self.closedList.size; i += 1)
        if (self.closedList[i].nodeIndex == nodeIndex)
            return i;

    return undefined;
}

getCost(from, to)
{
    start = blanco\waypoints::getNode(from).origin;
    end = blanco\waypoints::getNode(to).origin;
    return distanceSquared(start, end);
}

getHeuristic(from, to)
{
    start = blanco\waypoints::getNode(from).origin;
    end = blanco\waypoints::getNode(to).origin;
    return distanceSquared(start, end);
}