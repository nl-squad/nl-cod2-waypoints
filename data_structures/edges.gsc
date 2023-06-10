
EdgesCreate()
{
    edges = spawnStruct();
    edges.elements = [];

    return edges;
}

EdgesInsert(edges, fromUid, toUid, weight, type)
{
    from = fromUid + "";
    to = toUid + "";

    // printLn("Inserted edge from " + from + " to " + to);
    // iprintLn("Inserted edge from " + from + " to " + to);

    if (!isDefined(edges.elements[from]))
    {
        edges.elements[from] = spawnStruct();
        edges.elements[from].list = [];
        edges.elements[from].dictionary = [];
    }

    edgeStruct = spawnStruct();
    edgeStruct.from = fromUid;
    edgeStruct.to = toUid;
    edgeStruct.weight = weight;
    edgeStruct.type = type;

    assert(!isDefined(edges.elements[from].dictionary[to]));

    n = edges.elements[from].list.size;
    edges.elements[from].list[n] = edgeStruct;
    edges.elements[from].dictionary[to] = n;
}

EdgesGetFrom(edges, from)
{
    from = from + "";

    if (!isDefined(edges.elements[from]))
        return [];

    return edges.elements[from].list;
}

EdgesDelete(edges, from, to)
{
    from = from + "";
    to = to + "";

    assert(isDefined(edges.elements[from]));
    assert(isDefined(edges.elements[from].dictionary[to]));

    index = edges.elements[from].dictionary[to];

    newEdges = [];
    for (i = 0; i < edges.elements[from].list.size; i += 1)
        if (i != index)
            newEdges[newEdges.size] = edges.elements[from].list[i];

    edges.elements[from].list = newEdges;
    edges.elements[from].dictionary[to] = undefined;
}

EdgesExists(edges, from, to)
{
    from = from + "";
    to = to + "";

    return isDefined(edges.elements[from])
        && isDefined(edges.elements[from].dictionary[to]);
}

EdgesGet(edges, from, to)
{
    from = from + "";
    to = to + "";

    if (!isDefined(edges.elements[from]) || !isDefined(edges.elements[from].dictionary[to]))
        return [];

    index = edges.elements[from].dictionary[to];
    return edges.elements[from].list[index];
}
