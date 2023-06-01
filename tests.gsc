
test(name, function)
{
    if (isDefined(level.tests))
        level.tests = [];

    struct = spawnStruct();
    struct.name = name;
    struct.function = function;

    level.tests[level.tests.size] = struct;
}

RunAll()
{
    LogPrint("1 Starting tests...\n");
    Print("2 Starting tests...\n");
    PrintLn("3 Starting tests...");

    if (!isDefined(level.tests))
    {
        iPrintln("^1No tests defined");
        return;
    }

    for (i = 0; i < level.tests.size; i += 1)
    {
        [[ level.tests[i].function ]]();
        iPrintln(level.tests[i].name + "... ok");
    }

    iPrintln("Run " + level.tests.size + " tests");
}
