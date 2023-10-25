
Main()
{
    level.EDGE_NORMAL = 0;
    level.EDGE_CROUCH = 1;
    level.EDGE_PRONE = 2;
    level.EDGE_JUMP = 3;
    level.EDGE_LADDER = 4;
    level.EDGE_MANTLE = 5;
    level.EDGE_TYPES_COUNT = 6;
}

GetDisplayNameForEdgeType()
{
    if (edgeType == level.EDGE_NORMAL)
        return "^2Normal";

    if (edgeType == level.EDGE_CROUCH)
        return "^4Crouch";

    if (edgeType == level.EDGE_PRONE)
        return "^6Prone";

    if (edgeType == level.EDGE_JUMP)
        return "^5Jump";

    if (edgeType == level.EDGE_LADDER)
        return "^1Ladder";

    if (edgeType == level.EDGE_MANTLE)
        return "^8Mantle";

    return "Unknown";
}
