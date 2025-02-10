
using Godot;
using Godot.Collections;
using Google.Cloud.Firestore;
using System;
using System.Collections.Generic;
using System.Linq;


public partial class RealTimeUserService : Node
{
    [Signal]
    public delegate void UserDataChangedEventHandler(Dictionary newData);
    [Signal]
    public delegate void GamesOwnedChangedEventHandler(Variant newData);

    FireBaseConf conf;
    Node gdFireBase;
    public override async void _Ready()
    {
        conf = GetNode<FireBaseConf>("/root/FireBaseConf");
        gdFireBase = GetNode<Node>("/root/Firebase");
        conf.Connect("FirebaseConfigured", Callable.From(OnFirebaseConfigured));
    }

    private async void OnFirebaseConfigured()
    {
        var collection = conf.db.Collection("users");
        var auth = (Node)gdFireBase.Get("Auth");
        var authDict = (Dictionary)auth.Get("auth");
        var userId = (string)authDict["localid"];
        var document = collection.Document(userId);
        try
        {
            DocumentSnapshot snapshot = await document.GetSnapshotAsync();
        }
        catch (Exception e)
        {
            GD.PrintErr("Firestore error: ", e.ToString());
        }
        FirestoreChangeListener listener = document.Listen(snapshot =>
        {
            if (snapshot.Exists)
            {
                CallDeferred("EmitUserDataChanged", DictionaryConverter.ConvertToGodotDictionary(snapshot.ToDictionary()));
            }
            else
            {
                GD.Print("Document does not exist.");
            }
        });


        var gamesCollection = conf.db.Collection("users/" + userId  + "/games");
        gamesCollection.Listen(snapshot =>
        {
            var content = new Godot.Collections.Array<Godot.Collections.Dictionary<string, Variant>>(snapshot
                .ToArray()
                .Select(element => DictionaryConverter.ConvertToGodotDictionary(element.ToDictionary())));

            CallDeferred("EmitGamesOwnedChanged", content);
        });
    }

    private void EmitUserDataChanged(Dictionary dict)
    {
        EmitSignal("UserDataChanged", dict);
    }

    private void EmitGamesOwnedChanged(Variant data)
    {
        EmitSignal("GamesOwnedChanged", data);
    }
}
