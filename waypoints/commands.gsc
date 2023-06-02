Main()
{
    level.commands = [];
    defineCvar("start", ::start);

    thread commandsLoop();
}

defineCvar(name, function)
{
    commandStruct = spawnStruct();
    commandStruct.name = name;
    commandStruct.function = function;

    setCvar(name, "");
    n = level.commands.size;
    level.commands[n] = commandStruct;
}

commandsLoop()
{
    while (true)
    {
        for (i = 0; i < level.commands.size; i += 1)
        {
            commandStruct = level.commands[i];
            currentValue = getCvar(commandStruct.name);
            if (currentValue == "")
                continue;

            setCvar(commandStruct.name, "");
            args = StrTok(currentValue, " ");
            [[ commandStruct.function ]](args);
        }

        wait 0.5;
    }
}

start()
{
    iPrintln("hello world");
}