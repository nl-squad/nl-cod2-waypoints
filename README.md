# nl-cod2-nodes

The aim of this project is to enable nodes and edges configuration for any given map. Nodes and edges will be used as the base structure for bot path-finding.

## Conventions 🧐

1. **Node** - a point in 3D space that will be used for bot path-finding
2. **Edge** - a connection between 2 nodes, it has it's weight and type defined
    - types: normal, crouch, prone, ladder, mantle
    - weight: is a distance between those 2 nodes

## Usage 🚀

| Action | Invoking |
| ----------- | ----------- |
| Add new node | Click use button `F`. The node will be placed at your character's current position. |
| Add new edge | Look at the node A. Press and hold use button `F` and drag to the node B. Release use button. |
| Remove node | Look at the node and press melee button `Shift` |
| Remove edge | Look at the edge and press melee button `Shift` |
| Change edge type | Look at the edge and press shoot button `LMB` |

Note: To move existing node, it's required to remove the existing one and creating a new one.