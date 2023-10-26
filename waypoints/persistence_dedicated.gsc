#include blanco\utils;
#include blanco\math;
#include blanco\data_structures\edges;
#include blanco\data_structures\nodes;

Main()
{
    level.FLOAT_PERSIST_PRECISSION = 1000;

    level.LOAD_WAYPOINTS = ::Load;
    level.SAVE_WAYPOINTS = ::Save;
}

Load()
{
    loadNodesFromDatabase();
    loadEdgesFromDatabase();
}

Save()
{
    saveNodesToDatabase();
    saveEdgesToDatabase();
}

saveNodesToDatabase()
{
    sql = "INSERT INTO cod2_zom_waypoints_nodes (mapName, uid, origin0, origin1, origin2) VALUES ";

    nodes = NodesGetAll(level.nodes);
    for (i = 0; i < nodes.size; i += 1)
    {
        node = nodes[i];

        org0 = ceil(node.origin[0] * level.FLOAT_PERSIST_PRECISSION);
        org1 = ceil(node.origin[1] * level.FLOAT_PERSIST_PRECISSION);
        org2 = ceil(node.origin[2] * level.FLOAT_PERSIST_PRECISSION);

        sql += "('" + getCvar("mapname") + "', '" + node.uid + "', " + org0 + ", " + org1 + ", " + org2 + "), ";
    }

    sql = getSubStr(sql, 0, sql.size - 2);
    AsyncQueryNoSave(sql);
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
