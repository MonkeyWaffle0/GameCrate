using Godot;
using System;
using System.Collections.Generic;

public partial class DictionaryConverter : Node
{
    public static Godot.Collections.Dictionary<string, Variant> ConvertToGodotDictionary(Dictionary<string, object> input)
    {
        var godotDict = new Godot.Collections.Dictionary<string, Variant>();

        foreach (var kvp in input)
        {
            godotDict[kvp.Key] = ConvertToVariant(kvp.Value);
        }

        return godotDict;
    }

    private static Variant ConvertToVariant(object value)
    {
        switch (value)
        {
            case int intValue:
                return intValue;

            case string stringValue:
                return stringValue;

            case float floatValue:
                return floatValue;

            case bool boolValue:
                return boolValue;

            case double doubleValue:
                return doubleValue;

            case Int64 intValue:
                return intValue;

            case Dictionary<string, object> nestedDict:
                return ConvertToGodotDictionary(nestedDict);

            case List<object> listValue:
                return ConvertToGodotArray(listValue);

            default:
                GD.PrintErr($"Unsupported type: {value.GetType()}");
                return "error";
        }
    }

    private static Godot.Collections.Array ConvertToGodotArray(List<object> inputList)
    {
        var godotArray = new Godot.Collections.Array();

        foreach (var item in inputList)
        {
            godotArray.Add(ConvertToVariant(item));
        }

        return godotArray;
    }
}