# nl-cod2-waypoints

The aim of this project is to enable waypoints and edges configuration for any given map. Waypoints and edges will be used as the base structure for bot path-finding.

## Conventions 🧐

1. **Waypoint** - a point in 3D space that will be used for bot path-finding
2. **Edge** - a connection between 2 waypoints, it has it's weight and type defined
    - types: normal, crouch, prone, ladder, mantle
    - weight: is a distance between those 2 waypoints

## Usage 🚀

| Action | Invoking |
| ----------- | ----------- |
| Add new waypoint | Click use button `F`. The waypoint will be placed at your character's current position. |
| Add new edge | Look at the waypoint A. Press and hold use button `F` and drag to the waypoint B. Release use button. |
| Remove waypoint | Look at the waypoint and press melee button `Shift` |
| Remove edge | Look at the edge and press melee button `Shift` |
| Change edge type | Look at the edge and press shoot button `LMB` |

Note: To move existing waypoint, it's required to remove the existing one and creating a new one.