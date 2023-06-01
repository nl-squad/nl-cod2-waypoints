
test(name, function)
{
    if (isDefined(level.tests))
        level.tests = [];

    struct = spawnStruct();
    struct.name = name;
    struct.function = function;

    level.tests[level.tests.size] = struct;
}

run()
{
    for (i = 0; i < level.tests.size; i += 1)
    {
        [[ level.tests[i].function ]]();
        iPrintln(level.tests[i].name + "... ok");
    }
}