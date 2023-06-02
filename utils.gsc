printArray(array, name, printItemFunction)
{
    if (array.size == 0)
    {
        iPrintLn(name + "(0) = [empty]");
        return;
    }

    if (!isDefined(printItemFunction))
        printItemFunction = ::printDefault;

    message = name + "(" + array.size + ") = [";
    for (i = 0; i < array.size; i += 1)
        message += [[printItemFunction]](array[i]) + ", ";

    message = GetSubStr(message, 0, message.size - 2) + "]";
    iPrintln(message);
}

printDefault(item)
{
    return item;
}

printEdge(item)
{
    return "(to=" + item.to + ", w=" + item.weight + ")";
}

