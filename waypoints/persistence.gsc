Main()
{
    level.FLOAT_PERSIST_PRECISSION = 1000;
}

Load()
{
    fileHander("read", "nodes", ::loadNodes);
    fileHander("read", "edges", ::loadEdges);
}

Save()
{
    fileHander("write", "nodes", ::printNodes);
    fileHander("write", "edges", ::printEdges);
}

fileHander(mode, suffix, handlingFunction)
{
    mapName = getCvar("mapname");
    fileName = mapName + "_" + suffix + ".wp";

    fileHandle = openFile(fileName, mode);

    if (fileHandle == -1)
    {
        printLn("^1Can't open " + fileName + " with mode " + mode);
        iPrintLnBold("^1Can't open " + fileName + " with mode " + mode);
        return;
    }

    if (mode == "write")
    {
        [[ handlingFunction ]](fileHandle);
    }
    else if (mode == "read")
    {
        argumentsCount = fReadLn(fileHandle);
        while (argumentsCount > 0)
        {
            [[ handlingFunction ]](fileHandle, argumentsCount);
            argumentsCount = fReadLn(fileHandle);
        }
    }

    closeResponse = closeFile(fileHandle);

    if (closeResponse != 1)
    {
        printLn("^1Can't close " + fileName + " with mode " + mode);
        iPrintLnBold("^1Can't close " + fileName + " with mode " + mode);
        return;
    }
}

printNodes(fileHandle)
{
    nodes = NodesGetAll(level.nodes); // TODO: Implement NodesGetAll
    for (i = 0; i < nodes.size; i += 1)
    {
        node = nodes[i];
        fPrintLn(fileHandle, node.uid);
        fPrintLn(fileHandle, ceil(node.origin[0] * level.FLOAT_PERSIST_PRECISSION));
        fPrintLn(fileHandle, ceil(node.origin[1] * level.FLOAT_PERSIST_PRECISSION));
        fPrintLn(fileHandle, ceil(node.origin[2] * level.FLOAT_PERSIST_PRECISSION));
        fPrintLn(fileHandle, "\n");
    }
}

loadNodes(fileHandle, argumentsCount)
{
    uid = fGetArg(fileHandle, 0);

    originX = int(fGetArg(fileHandle, 1)) / level.FLOAT_PERSIST_PRECISSION;
    originY = int(fGetArg(fileHandle, 2)) / level.FLOAT_PERSIST_PRECISSION;
    originZ = int(fGetArg(fileHandle, 3)) / level.FLOAT_PERSIST_PRECISSION;
    origin = (originX, originY, originZ);

    NodesLoad(level.nodes, uid, origin);
}

printEdges(fileHandle)
{
    edges = EdgesGetAll(level.edges); // TODO: Implement EdgesGetAll
    for (i = 0; i < edges.size; i += 1)
    {
        edge = edges[i];
        fPrintLn(fileHandle, edge.fromUid);
        fPrintLn(fileHandle, edge.toUid);
        fPrintLn(fileHandle, ceil(edge.weight * level.FLOAT_PERSIST_PRECISSION));
        fPrintLn(fileHandle, edge.type);
        fPrintLn(fileHandle, ceil(edge.selectOrigin[0] * level.FLOAT_PERSIST_PRECISSION));
        fPrintLn(fileHandle, ceil(edge.selectOrigin[1] * level.FLOAT_PERSIST_PRECISSION));
        fPrintLn(fileHandle, ceil(edge.selectOrigin[2] * level.FLOAT_PERSIST_PRECISSION));
        fPrintLn(fileHandle, "\n");
    }
}

loadEdges(fileHandle, argumentsCount)
{
    fromUid = fGetArg(fileHandle, 0);
    toUid = fGetArg(fileHandle, 1);
    weight = int(fGetArg(fileHandle, 2)) / level.FLOAT_PERSIST_PRECISSION;
    type = int(fGetArg(fileHandle, 3));

    originX = int(fGetArg(fileHandle, 4)) / level.FLOAT_PERSIST_PRECISSION;
    originY = int(fGetArg(fileHandle, 5)) / level.FLOAT_PERSIST_PRECISSION;
    originZ = int(fGetArg(fileHandle, 6)) / level.FLOAT_PERSIST_PRECISSION;
    selectOrigin = (originX, originY, originZ);

    EdgesInsert(level.edges, fromUid, toUid, weight, type, selectOrigin);
}

ceil(num)
{
    floor = int(num);
    if (num == floor)
        return floor;

    return floor + 1;
}
