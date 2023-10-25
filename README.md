# nl-cod2-nodes

The aim of this project is to enable nodes and edges configuration for any given map. Nodes and edges will be used as the base structure for bot path finding.

## Conventions 🧐

1. **Node** - a point in 3D space that will be used for bot path finding
2. **Edge** - a connection between 2 nodes, it has it's weight and type defined.
    - types:
    <span style="color: rgb(46, 204, 113)">normal ![#2ecc71](https://placehold.co/12x12/2ecc71/2ecc71.png)</span>,
    <span style="color: rgb(52, 152, 219)">crouch ![#3498db](https://placehold.co/12x12/3498db/3498db.png)</span>,
    <span style="color: rgb(155, 89, 182)">prone ![#9b59b6](https://placehold.co/12x12/9b59b6/9b59b6.png)</span>,
    <span style="color: rgb(231, 76, 60)">ladder ![#e74c3c](https://placehold.co/12x12/e74c3c/e74c3c.png)</span>,
    <span style="color: rgb(241, 196, 15)">mantle ![#f1c40f](https://placehold.co/12x12/f1c40f/f1c40f.png)</span>,
    <span style="color: rgb(72, 219, 251)">jump ![#48dbfb](https://placehold.co/12x12/48dbfb/48dbfb.png)</span>,
    <span style="color: rgb(149, 165, 166)">unaccessible ![#95a5a6](https://placehold.co/12x12/95a5a6/95a5a6.png)</span>.
    - weight: is a distance between those 2 nodes (calculated automatically)
    - each node is directional. It means that
        - If node A is accessible from B, and B is accessible from A, then there need to be 2 edges defined.
        - If going to node A from node B requires mantle then the edge (A to B) should be <span style="color: rgb(241, 196, 15)">mantle ![#f1c40f](https://placehold.co/12x12/f1c40f/f1c40f.png)</span> type. And if going back requires just drop then the second edge (B to A) should be type <span style="color: rgb(46, 204, 113)">normal ![#2ecc71](https://placehold.co/12x12/2ecc71/2ecc71.png)</span>. 
        - If going A to B is possible. But going B to A is **impossible**. Then there should be 2 edges A to B with type <span style="color: rgb(46, 204, 113)">normal ![#2ecc71](https://placehold.co/12x12/2ecc71/2ecc71.png)</span> and B to A with type <span style="color: rgb(149, 165, 166)">unaccessible ![#95a5a6](https://placehold.co/12x12/95a5a6/95a5a6.png)</span>.

## Usage 🚀

| Action | Invoking |
| ----------- | ----------- |
| Add new node | Click use button `F`. The node will be placed at your character's current position. |
| Add new edge | Look at the node A. Press and hold use button `F` and drag to the node B. Release use button. |
| Remove node | Look at the node and press melee button `Shift` |
| Remove edge | Look at the edge and press melee button `Shift` |
| Change edge type | Look at the edge and press shoot button `LMB` |

Note: To move existing node, it's required to remove the existing one and creating a new one.