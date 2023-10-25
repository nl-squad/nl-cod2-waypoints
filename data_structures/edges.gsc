
EdgesCreate()
{
    edges = spawnStruct();
    edges.elements = [];

    return edges;
}

EdgesInsert(edges, fromUid, toUid, weight, type, selectOrigin)
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
    edgeStruct.selectOrigin = selectOrigin;

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

EdgesChangeType(edges, from, to, newType)
{
    edge = EdgesGet(edges, from, to);

    if (!isDefined(newType))
        newType = (edge.type + 1) % level.EDGE_TYPES_COUNT;

    edge.type = newType;
    return edge.type;
}

CalculateSelectOrigins(startOrigin, endOrigin)
{
    midDistance = distance(startOrigin, endOrigin) / 2;
    normal = vectorNormalize(endOrigin - startOrigin);

    selectOrigins = spawnStruct();
    selectOrigins.to = startOrigin + maps\mp\_utility::vectorScale(normal, midDistance - level.EDGE_SELECTOR_OFFSET);
    selectOrigins.reverse = startOrigin + maps\mp\_utility::vectorScale(normal, midDistance + level.EDGE_SELECTOR_OFFSET);
    return selectOrigins;
}