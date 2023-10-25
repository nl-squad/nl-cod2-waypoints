Main()
{
    blanco\data_structures\nodes_tests::Main();
    blanco\data_structures\edges_tests::Main();
    blanco\data_structures\integration_tests::Main();
    blanco\tests::RunAll();

    blanco\waypoints\display_dedicated::Main();
    blanco\waypoints\edge_types::Main();
    blanco\waypoints\interactions::Main();
    blanco\waypoints\persistence_dedicated::Main();
}
