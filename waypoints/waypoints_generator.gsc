
Start(startOrigin)
{
    chunks_create

    add startOrigin to chunks

    add startOrigin to openSet

    while( get from openSet is defined )
    {
        call discoverFromNode
    }

}

function discoverFromNode(node)
{
    get neighbours

    for each neighbour
    {
        if neighbour is alredy in chunks
            continue

        add neighbour to chunks
        add edge from node to neighbour

        if gettype(neighbour, node) is defined
            add edge from neighbour to node
    }
}

function getNeighbours
{
    neighbours = []
    get directions

    for each direction
    {
        origin up
        origin up cap if ceiling is lower

        origin to direction
        origin to direction cap if wall is closer

        origin put on ground

        type = gettype(node, neighbour)

        if type == undefined
            continue

        add to neighbours (with type)
    }

    return neighbours
}

gettype node neighbour
{
    // if slope to steep
        return undefined

    if spaceOverHeadA or spavOverHeadB < prone minimal
        return undefined

    if spaceOverHeadA or spavOverHeadB < crouch minimal
        return prone

    if spaceOverHeadA or spaceOverHeadB < stand minimal
        return crouch

    if bullettrace not clear and node.z > neighbour.z
        return jump

    return stand
}

F // Adding node (origin)
melee // Removing node (origin)
F // Adding edge (node1, node2)
melee // Remove edge (node1, node2)
F // Chaning edge type
command // Re-run generation
command // Clear
F + melee // Creating path - replace points in grid with manually added
// Edge types - jump, crouch, prone, ladder

// mantle, elevators, teleporters, ladders
