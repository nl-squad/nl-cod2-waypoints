Main()
{
    level.FLOAT_PERSIST_PRECISSION = 1000;
}

Load()
{
    if (isDev())
    {
        loadNodesFromDatabase();
        loadEdgesFromDatabase();
        return;
    }

    fileHander("read", "nodes", ::loadNodesFromFile);
    fileHander("read", "edges", ::loadEdgesFromFile);
}

Save()
{
    if (isDev())
    {
        saveNodesToDatabase();
        saveEdgesToDatabase();
        return;
    }

    fileHander("write", "nodes", ::saveNodesToFile);
    fileHander("write", "edges", ::saveEdgesToFile);
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

saveNodesToFile(fileHandle)
{
    nodes = NodesGetAll(level.nodes);
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

saveNodesToDatabase()
{
    sql = "INSERT INTO cod2_zom_waypoints_nodes (mapName, uid, origin0, origin1, origin2) VALUES ";

    nodes = NodesGetAll(level.nodes);
    for (i = 0; i < nodes.size; i += 1)
    {
        node = nodes[i];

        org0 = ceil(edge.selectOrigin[0] * level.FLOAT_PERSIST_PRECISSION);
        org1 = ceil(edge.selectOrigin[1] * level.FLOAT_PERSIST_PRECISSION);
        org2 = ceil(edge.selectOrigin[2] * level.FLOAT_PERSIST_PRECISSION);

        sql += "('" + getCvar("mapname") + "', '" + node.uid + "', " + org0 + ", " + org1 + ", " + org2 + "), ";
    }

    sql = getSubStr(sql, 0, sql.size - 2);
    AsyncQueryNoSave(sql);
}

loadNodesFromFile(fileHandle, argumentsCount)
{
    uid = fGetArg(fileHandle, 0);

    originX = int(fGetArg(fileHandle, 1)) / level.FLOAT_PERSIST_PRECISSION;
    originY = int(fGetArg(fileHandle, 2)) / level.FLOAT_PERSIST_PRECISSION;
    originZ = int(fGetArg(fileHandle, 3)) / level.FLOAT_PERSIST_PRECISSION;
    origin = (originX, originY, originZ);

    NodesLoad(level.nodes, uid, origin);
}

loadNodesFromDatabase()
{
    sql = "SELECT uid, origin0, origin1, origin2 FROM cod2_zom_waypoints_nodes WHERE mapName='" + getCvar("mapname") + "'";

    AsyncQuery(sql, ::loadedNodesFromDatabase);
}

loadedNodesFromDatabase(result)
{
    row = mysql_fetch_row(result);

    while (isDefined(row))
    {
        originX = int(row[1]) / level.FLOAT_PERSIST_PRECISSION;
        originY = int(row[2]) / level.FLOAT_PERSIST_PRECISSION;
        originZ = int(row[3]) / level.FLOAT_PERSIST_PRECISSION;
        origin = (originX, originY, originZ);

        NodesLoad(level.nodes, row[0], origin);

        row = mysql_fetch_row(result);
    }

    mysql_free_result(result);
}

saveEdgesToFile(fileHandle)
{
    edges = EdgesGetAll(level.edges);
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

saveEdgesToDatabase()
{
    sql = "INSERT INTO cod2_zom_waypoints_edges (mapName, fromUid, toUid, weight, type, selectOrigin0, selectOrigin1, selectOrigin2) VALUES ";

    edges = EdgesGetAll(level.edges);
    for (i = 0; i < edges.size; i += 1)
    {
        edge = edges[i];

        org0 = ceil(edge.selectOrigin[0] * level.FLOAT_PERSIST_PRECISSION);
        org1 = ceil(edge.selectOrigin[1] * level.FLOAT_PERSIST_PRECISSION);
        org2 = ceil(edge.selectOrigin[2] * level.FLOAT_PERSIST_PRECISSION);
        weight = ceil(edge.weight * level.FLOAT_PERSIST_PRECISSION);

        sql += "('" + getCvar("mapname") + "', '" + edge.fromUid + "', " + edge.toUid + ", " + weight + ", " + edge.type + ", " + org0 + ", " + org1 + ", " + org2 + "), ";
    }

    sql = getSubStr(sql, 0, sql.size - 2);
    AsyncQueryNoSave(sql);
}

loadEdgesFromFile(fileHandle, argumentsCount)
{
    fromUid = fGetArg(fileHandle, 0);
    toUid = fGetArg(fileHandle, 1);
    weight = int(fGetArg(fileHandle, 2)) / level.FLOAT_PERSIST_PRECISSION;
    type = int(fGetArg(fileHandle, 3));

    originX = int(fGetArg(fileHandle, 4)) / level.FLOAT_PERSIST_PRECISSION;
    originY = int(fGetArg(fileHandle, 5)) / level.FLOAT_PERSIST_PRECISSION;
    originZ = int(fGetArg(fileHandle, 6)) / level.FLOAT_PERSIST_PRECISSION;
    selectOrigin = (originX, originY, originZ);

    EdgesLoad(level.edges, fromUid, toUid, weight, type, selectOrigin);
}

loadEdgesFromDatabase()
{
    sql = "SELECT fromUid, toUid, weight, type, selectOrigin0, selectOrigin1, selectOrigin2 FROM cod2_zom_waypoints_edges WHERE mapName='" + getCvar("mapname") + "'";

    AsyncQuery(sql, ::loadedEdgesFromDatabase);
}

loadedEdgesFromDatabase(result)
{
    row = mysql_fetch_row(result);

    while (isDefined(row))
    {
        fromUid = row[0];
        toUid = row[1];
        weight = int(row[2]) / level.FLOAT_PERSIST_PRECISSION;
        type = int(row[3]);
        
        originX = int(row[4]) / level.FLOAT_PERSIST_PRECISSION;
        originY = int(row[5]) / level.FLOAT_PERSIST_PRECISSION;
        originZ = int(row[6]) / level.FLOAT_PERSIST_PRECISSION;
        selectOrigin = (originX, originY, originZ);

        EdgesLoad(level.edges, fromUid, toUid, weight, type, selectOrigin);

        row = mysql_fetch_row(result);
    }

    mysql_free_result(result);
}

ceil(num)
{
    floor = int(num);
    if (num == floor)
        return floor;

    return floor + 1;
}
