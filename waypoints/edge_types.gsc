
Main()
{
    level.EDGE_TYPES = [];
    level.EDGE_NORMAL = defineEdgeType("^2normal", 0, rgb(46, 204, 113));
    level.EDGE_CROUCH = defineEdgeType("^4crouch", 1, rgb(52, 152, 219));
    level.EDGE_PRONE = defineEdgeType("^6prone", 2, rgb(155, 89, 182));
    level.EDGE_LADDER = defineEdgeType("^1ladder", 3, rgb(241, 196, 15));
    level.EDGE_MANTLE = defineEdgeType("^3mantle", 4, rgb(72, 219, 251));
}

defineEdgeType(name, value, color)
{
    edgeType = spawnStruct();
    edgeType.name = name;
    edgeType.value = value;
    edgeType.color = color;

    return value;
}

rgb(red, green, blue)
{
    color = (red / 255, green / 255, blue / 255);
    return color;
}

GetDisplayNameForEdgeType(edgeType)
{
    for (i = 0; i < level.EDGE_TYPES.size; i += 1)
        if (level.EDGE_TYPES[i].value == edgeType)
            return level.EDGE_TYPES[i].name;

    return "Unknown";
}

GetColorForEdgeType(edgeType)
{
    for (i = 0; i < level.EDGE_TYPES.size; i += 1)
        if (level.EDGE_TYPES[i].value == edgeType)
            return level.EDGE_TYPES[i].color;

    defaultColor = (1, 1, 1);
    return defaultColor;
}
