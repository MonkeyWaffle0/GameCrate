
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
        GD.Print("Listening to user changes...");
        var userCollection = conf.db.Collection("users"); ;
        var document = userCollection.Document(conf.userId);

        FirestoreChangeListener listener = document.Listen(snapshot =>
        {
            GD.Print("User data changed.");
            if (snapshot.Exists)
            {
                CallDeferred("EmitUserDataChanged", DictionaryConverter.ConvertToGodotDictionary(snapshot.ToDictionary()));
            }
            else
            {
                GD.Print("Document does not exist.");
            }
        });

        GD.Print("Listening to games changes...");
        var gamesCollection = conf.db.Collection("users/" + conf.userId + "/games");
        gamesCollection.Listen(snapshot =>
        {
            GD.Print("Game collection data changed.");
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
