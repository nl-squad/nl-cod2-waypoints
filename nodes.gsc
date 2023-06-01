
NodesCreate()
{
    nodes = spawnStruct();
    nodes.elements = [];

    return nodes;
}

NodesInsert(nodes, element)
{
    n = nodes.elements.size;
    nodes.elements[n] = element;

    return n;
}

NodesGet(nodes, index)
{
    return nodes.elements[index];
}

NodesDelete(nodes, index)
{
    elements = [];
    for (i = 0; i < nodes.elements.size; i += 1)
        if (i != index)
            elements[elements.size] = nodes.elements[i];

    nodes.elements = elements;
}
