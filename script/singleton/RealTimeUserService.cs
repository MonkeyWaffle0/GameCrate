
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
    [Signal]
    public delegate void FriendsChangedEventHandler(Variant newData);
    [Signal]
    public delegate void FriendsSentChangedEventHandler(Variant newData);
    [Signal]
    public delegate void FriendsReceivedChangedEventHandler(Variant newData);

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
        var userCollection = conf.db.Collection("users");
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

        GD.Print("Listening to friends...");
        var friendsCollection = conf.db.Collection("users/" + conf.userId + "/friends");
        friendsCollection.Listen(snapshot =>
        {
            GD.Print("Friends data changed.");
            var content = new Godot.Collections.Array<Godot.Collections.Dictionary<string, Variant>>(snapshot
                .ToArray()
                .Select(element =>
                {
                    var dic = element.ToDictionary();
                    dic.Add("id", element.Id);
                    return DictionaryConverter.ConvertToGodotDictionary(dic);
                }));

            CallDeferred("EmitFriendsChanged", content);
        });

        GD.Print("Listening to sent friends requests...");
        var friendsSentCollection = conf.db.Collection("users/" + conf.userId + "/friends_sent");
        friendsSentCollection.Listen(snapshot =>
        {
            GD.Print("Friends sent requests data changed.");
            var content = new Godot.Collections.Array<Godot.Collections.Dictionary<string, Variant>>(snapshot
                .ToArray()
                .Select(element =>
                {
                    var dic = element.ToDictionary();
                    dic.Add("id", element.Id);
                    return DictionaryConverter.ConvertToGodotDictionary(dic);
                }));
            CallDeferred("EmitFriendsSentChanged", content);
        });

        GD.Print("Listening to received friends requests...");
        var friendsReceivedCollection = conf.db.Collection("users/" + conf.userId + "/friends_received");
        friendsReceivedCollection.Listen(snapshot =>
        {
            GD.Print("Friends received requests data changed.");
            var content = new Godot.Collections.Array<Godot.Collections.Dictionary<string, Variant>>(snapshot
                .ToArray()
                .Select(element =>
                {
                var dic = element.ToDictionary();
                dic.Add("id", element.Id);
                return DictionaryConverter.ConvertToGodotDictionary(dic);
                }));
            CallDeferred("EmitFriendsReceivedChanged", content);
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

    private void EmitFriendsChanged(Variant data)
    {
        EmitSignal("FriendsChanged", data);
    }

    private void EmitFriendsSentChanged(Variant data)
    {
        EmitSignal("FriendsSentChanged", data);
    }

    private void EmitFriendsReceivedChanged(Variant data)
    {
        EmitSignal("FriendsReceivedChanged", data);
    }
}
