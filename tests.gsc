
test(name, function)
{
    if (!isDefined(level.tests))
        level.tests = [];

    struct = spawnStruct();
    struct.name = name;
    struct.function = function;

    level.tests[level.tests.size] = struct;
}

RunAll()
{
    PrintLn("---");
    PrintLn("Starting tests...");

    if (!isDefined(level.tests))
    {
        Println("Warning: No tests defined");
        return;
    }

    for (i = 0; i < level.tests.size; i += 1)
    {
        Println("Running test: " + level.tests[i].name);
        [[ level.tests[i].function ]]();
    }

    Println("Performed " + level.tests.size + " tests");
    PrintLn("---");
}
