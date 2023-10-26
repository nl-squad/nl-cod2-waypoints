# 🛣️ nl-cod2-waypoints

The aim of this project is to enable nodes and edges configuration for any given map. Nodes and edges will be used as the base structure for bot pathfinding.

# 🧐 Conventions

1. **Node** - a point in 3D space that will be used for bot path finding
2. **Edge** - a connection between 2 nodes, it has its weight and type defined.
    - types:
    <span style="color: rgb(46, 204, 113)">normal ![#2ecc71](https://placehold.co/12x12/2ecc71/2ecc71.png)</span>,
    <span style="color: rgb(52, 152, 219)">crouch ![#3498db](https://placehold.co/12x12/3498db/3498db.png)</span>,
    <span style="color: rgb(155, 89, 182)">prone ![#9b59b6](https://placehold.co/12x12/9b59b6/9b59b6.png)</span>,
    <span style="color: rgb(231, 76, 60)">ladder ![#e74c3c](https://placehold.co/12x12/e74c3c/e74c3c.png)</span>,
    <span style="color: rgb(241, 196, 15)">mantle ![#f1c40f](https://placehold.co/12x12/f1c40f/f1c40f.png)</span>,
    <span style="color: rgb(72, 219, 251)">jump ![#48dbfb](https://placehold.co/12x12/48dbfb/48dbfb.png)</span>.
    - weight: is the distance between those 2 nodes (calculated automatically)
    - each node is directional. It means that
        - If node A is accessible from B, and B is accessible from A, then there need to be 2 edges defined.
        - If going to node A from node B requires mantle then the edge (A to B) should be <span style="color: rgb(241, 196, 15)">mantle ![#f1c40f](https://placehold.co/12x12/f1c40f/f1c40f.png)</span> type. And if going back requires just a drop then the second edge (B to A) should be of type <span style="color: rgb(46, 204, 113)">normal ![#2ecc71](https://placehold.co/12x12/2ecc71/2ecc71.png)</span>. 
        - If going A to B is possible. But going from B to A is **impossible**. Then there should be 1 edge - A to B with type <span style="color: rgb(46, 204, 113)">normal ![#2ecc71](https://placehold.co/12x12/2ecc71/2ecc71.png)</span>.

# 🚀 Usage 

| Action | Invoking |
| ----------- | ----------- |
| Add new node | Click the use button `F`. The node will be placed at your character's current position. |
| Add new edge | Look at node A. Press and hold the use button `F` and drag it to node B. Release the use button. |
| Remove node | Look at the node and press the melee button `Shift` |
| Remove edge | Look at the edge and press the melee button `Shift` |
| Change edge type | Look at the edge and press shoot button `LMB` |

Note: To move an existing node, it's required to remove the existing one and create a new one.

## Roadmap 🛣️

1. ✅ Testing framework
2. ✅ Implement node structure with testing scenarios
    - ✅ Inserting
    - ✅ Getting
    - ✅ Removing
    - ✅ Get closest to the origin
    - ✅ Chunking (improved performance)
3. ✅ Implement edge structure with testing scenarios
    - ✅ Inserting
    - ✅ Getting
    - ✅ Removing
4. ✅ Waypoint game type
5. ✅ Player interactions
    - ✅ Inserting a new node
    - ✅ Inserting new edge
    - ✅ Removing node
    - ✅ Removing edge
    - ✅ Changing edge type
6. ✅ Displaying nodes and edges
    - ✅ Nodes displaying
    - ✅ Edges displaying
    - ✅ Edges type displaying
    - ✅ Show the currently selected node/edge (for deletion or edge drawing)
    - ✅ Displaying elements only in range
7. ✅ Saving nodes and edges for further use
8. ✅ Loading nodes and edges from saved file
9. ✅ Draw methods dependent on run environment
    - ✅ use light effects when in dedicated mode (no `developer_script` available on remote)
    - ✅ use `line` and `print3d` when in local mode
10. ✅ Save methods dependent on run environment
    - ✅ save to db when run in dedicated mode
    - ✅ save to file when run in local mode
11. ✅ Automatic edges discovery on new node insert

# 💡 Further development ideas

1. Automatic waypoint generation
