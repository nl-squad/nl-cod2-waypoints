#include blanco\utils;
#include blanco\data_structures\edges;
#include blanco\data_structures\nodes;

Main()
{
    level.MINIMUM_ANGLES_DIFFRENCE_FOR_EDGE_INSERT = 20;
    level.SELECT_ELEMENT_MAX_SQUARED_DISTANCE = 16 * 16;
    level.DISCOVERY_DISTANCE_SQUARED = 200 * 200;

    level.STAND_OFFSET = (0, 0, 72);
    level.CROUCH_OFFSET = (0, 0, 56);
    level.PRONE_OFFSET = (0, 0, 40);

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
    useButtonActivatedInitialNode = undefined;
    isMeleeButtonActivated = false;
    isShootButtonActivated = false;

    while (isDefined(self))
    {
        targetOrigin = self getTargetOrigin();
        targetNode = self getNodeInSelectRange(targetOrigin);
        targetEdge = self getEdgeInSelectRange(targetOrigin);

        self.targetedNode = targetNode;
        self.targetedEdge = targetEdge;

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
                deleteEdgeInteraction(targetEdge.fromUid, targetEdge.toUid);
                printAction("remove edge #" + targetNode.fromUid + " -> #" + targetEdge.toUid);
            }
        }

        // Shoot interactions
        if (!isShootButtonActivated && self attackButtonPressed())
            isShootButtonActivated = true;

        if (isShootButtonActivated && !self attackButtonPressed())
        {
            isShootButtonActivated = false;

            newType = changeEdgeTypeInteraction(targetEdge.fromUid, targetEdge.toUid);
            newTypeDisplayName = blanco\waypoints\edge_types::GetDisplayNameForEdgeType(newType);
            printAction("type edge #" + targetNode.fromUid + " -> #" + targetEdge.toUid + " " + newTypeDisplayName);
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
    insertedNode = NodesInsert(level.nodes, origin);

    nearbyNodes = NodesGetElementsInSquaredDistance(level.nodes, origin, level.DISCOVERY_DISTANCE_SQUARED);
    for (i = 0; i < nearbyNodes.size; i += 1)
    {
        edgeType = estimateEdgeType(insertedNode, nearbyNodes[i]);
        weight = EdgesCalculateDistance(insertedNode.origin, nearbyNodes[i].origin);
        selectOrigins = EdgesCalculateSelectOrigins(insertedNode.origin, nearbyNodes[i].origin);

        edgeFrom = EdgesInsert(level.edges, insertedNode.uid, nearbyNodes[i].uid, weight, edgeType, selectOrigins.forward);
        edgeTo = EdgesInsert(level.edges, nearbyNodes[i].uid, insertedNode.uid, weight, edgeType, selectOrigins.reverse);

        edgeTypeDisplayName = blanco\waypoints\edge_types::GetDisplayNameForEdgeType(edgeType);
        printAction("discover edge #" + edgeFrom.fromUid + " -> #" + edgeFrom.toUid + " " + edgeTypeDisplayName);
        printAction("discover edge #" + edgeTo.fromUid + " -> #" + edgeTo.toUid + " " + edgeTypeDisplayName);
    }

    return insertedNode;
}

insertEdgeInteraction(startNode, endNode)
{
    selectOrigins = EdgesCalculateSelectOrigins(startNode.origin, endNode.origin);
    weight = EdgesCalculateDistance(startNode.origin, endNode.origin);
    return EdgesInsert(level.edges, startNode.uid, endNode.uid, weight, level.EDGE_NORMAL, selectOrigins.forward);
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
    for (axis = 0; axis < 3; axis += 1)
    {
        axisDiff = (anglesB[axis] - anglesA[axis] + 180) % 360 - 180;

        if (axisDiff < 0)
            axisDiff = axisDiff * -1;
        
        diff += axisDiff;
    }

    return diff;
}

estimateEdgeType(startNode, endNode)
{
    standTrace = bulletTrace(startNode.origin + level.STAND_OFFSET, endNode.origin + level.STAND_OFFSET, false, undefined);
    crouchTrace = bulletTrace(startNode.origin + level.CROUCH_OFFSET, endNode.origin + level.CROUCH_OFFSET, false, undefined);
    proneTrace = bulletTrace(startNode.origin + level.PRONE_OFFSET, endNode.origin + level.PRONE_OFFSET, false, undefined);

    if (standTrace["fraction"] == 1 && crouchTrace["fraction"] == 1 && proneTrace["fraction"] == 1)
        return level.EDGE_NORMAL;
    
    if (standTrace["fraction"] < 1 && crouchTrace["fraction"] == 1 && proneTrace["fraction"] == 1)
        return level.EDGE_CROUCH;
    
    if (standTrace["fraction"] < 1 && crouchTrace["fraction"] < 1 && proneTrace["fraction"] == 1)
        return level.EDGE_PRONE;
    
    if (standTrace["fraction"] == 1 && crouchTrace["fraction"] < 1 && proneTrace["fraction"] < 1)
        return level.EDGE_MANTLE;

    return undefined;
}
