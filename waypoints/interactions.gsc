#include blanco\utils;
#include blanco\data_structures\edges;
#include blanco\data_structures\nodes;

Main()
{
    level.MINIMUM_ANGLES_DIFFRENCE_FOR_EDGE_INSERT = 20;
    level.SELECT_ELEMENT_MAX_SQUARED_DISTANCE = 16 * 16;

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
    useButtonActivatedAngles = undefined;
    isMeleeButtonActivated = false;
    isShootButtonActivated = false;

    while (isDefined(self))
    {
        targetOrigin = self getTargetOrigin();
        targetNode = self getNodeInSelectRange(origin);
        targetEdge = self getEdgeInSelectRange(origin);

        // Use interactions
        if (!isDefined(useButtonActivatedAngles) && self useButtonPressed())
        {
            useButtonActivatedAngles = self getPlayerAngles();
            useButtonActivatedInitialNode = targetNode;
        }

        if (isDefined(useButtonActivatedAngles) && !self useButtonPressed()) // [F] button released
        {
            anglesDifference = getAnglesDifference(useButtonActivatedAngles, self getPlayerAngles());
            iPrintln(anglesDifference);

            if (anglesDifference < level.MINIMUM_ANGLES_DIFFRENCE_FOR_EDGE_INSERT)
            {
                insertedNode = insertNodeInteraction(self GetOrigin());
                printAction("insert node #" + insertedNode.uid);
            }
            else if (isDefined(useButtonActivatedInitialNode) && isDefined(targetNode))
            {
                insertedEdge = insertEdgeInteraction(useButtonActivatedInitialNode, targetNode);
                printAction("insert edge #" + insertedEdge.fromUid + " -> #" + insertedEdge.toUid);
            }

            useButtonActivatedAngles = undefined;
            useButtonActivatedInitialNode = undefined;
        }

        // Melee interactions
        if (!isMeleeButtonActivated && self meleeButtonPressed())
            isMeleeButtonActivated = true;

        if (isMeleeButtonActivated && !self meleeButtonPressed())
        {
            isMeleeButtonActivated = false;
            nodeOrEdge = isRemovingNodeOrEdge(targetNode, targetEdge, targetOrigin);

            if (nodeOrEdge == 1)
            {
                deleteNodeInteraction(targetNode.uid);
                printAction("remove node #" + targetNode.uid);
            }
            else if (nodeOrEdge == 2)
            {
                deleteEdgeInteraction(targetEdge.from, targetEdge.to);
                printAction("remove edge #" + targetNode.from + " -> #" + targetEdge.to);
            }
        }

        // Shoot interactions
        if (!isShootButtonActivated && self attackButtonPressed())
            isShootButtonActivated = true;

        if (isShootButtonActivated && !self attackButtonPressed())
        {
            isShootButtonActivated = false;

            newType = changeEdgeTypeInteraction(targetEdge.from, targetEdge.to);
            newTypeDisplayName = blanco\waypoints\edge_types::GetDisplayNameForEdgeType(newType);
            printAction("type edge #" + targetNode.from + " -> #" + targetEdge.to + " " + newTypeDisplayName);
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
    return NodesGetClosestElementInSquareDistance(level.nodes, origin, level.SELECT_ELEMENT_MAX_SQUARED_DISTANCE);
}

getEdgeInSelectRange(origin)
{
    return EdgesGetClosestElementInSquareDistance(level.edges, origin, level.SELECT_ELEMENT_MAX_SQUARED_DISTANCE);
}

insertNodeInteraction(origin)
{
    return NodesInsert(level.nodes, origin);
}

insertEdgeInteraction(startNode, endNode)
{
    midDistance = distance(existingNode.origin, node.origin) / 2;
    differenceNormalVector = vectorNormalize(existingNode.origin - node.origin);
    toSelectOrigin = node.origin + maps\mp\_utility::vectorScale(differenceNormalVector, midDistance - level.EDGE_SELECTOR_OFFSET);
    reverseSelectOrigin = node.origin + maps\mp\_utility::vectorScale(differenceNormalVector, midDistance + level.EDGE_SELECTOR_OFFSET);

    weight = distance(startNode.origin, endNode.origin);
    return EdgesInsert(level.edges, startNode.uid, endNode.uid, weight, level.EDGE_NORMAL);
}

deleteNodeInteraction(node)
{
    NodesDelete(level.nodes, node.uid);
    EdgesDeleteFrom(level.edges, node.uid);
    EdgesDeleteTo(level.edges, node.uid);
}

deleteEdgeInteraction(from, to)
{
    EdgesDelete(level.edges, from, to);
}

changeEdgeTypeInteraction(from, to)
{
    return EdgesChangeType(level.edges, from, to);
}

startDrawingEdgeInteraction(node)
{
    self.drawEdgeStartingNode = node;
}

isRemovingNodeOrEdge(targetNode, targetEdge, targetOrigin)
{
    if (!isDefined(targetNode) && !isDefined(targetEdge))
        return 0;

    if (isDefined(targetNode) && !isDefined(targetEdge))
        return 1;

    if (!isDefined(targetNode) && isDefined(targetEdge))
        return 2;

    distanceToNode = distanceSquared(targetNode.origin, targetOrigin);
    distanceToEdge = distanceSquared(targetEdge.selectOrigin, targetOrigin);

    if (distanceToNode < distanceToEdge)
        return 1;

    return 2;
}

printAction(message)
{
    self iPrintlnBold(message);
}

getAnglesDifference(anglesA, anglesB)
{
    diff = 0;
    for (i = 0; i < 3; i += 1)
    {
        axisDiff = (anglesB[axis] - anglesA[axis] + 180) % 360 - 180;

        if (axisDiff < 0)
            axisDiff = axisDiff * -1;
        
        diff += axisDiff;
    }

    return diff;
}
