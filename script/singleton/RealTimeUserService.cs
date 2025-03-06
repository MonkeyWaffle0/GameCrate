
using System.Linq;
using Godot;
using Godot.Collections;
using Google.Cloud.Firestore;


public partial class RealTimeUserService : Node
{
    [Signal]
    public delegate void UserDataChangedEventHandler(Dictionary newData);
    [Signal]
    public delegate void GamesOwnedChangedEventHandler(Variant newData);
    [Signal]
    public delegate void FriendshipsChangedEventHandler(Variant newData);
    [Signal]
    public delegate void SessionChangedEventHandler(Dictionary newData);
    [Signal]
    public delegate void LikesChangedEventHandler(Variant newData);
    [Signal]
    public delegate void SessionsChangedEventHandler(Variant newData);

    FireBaseConf conf;
    Node gdFireBase;

    private System.Collections.Generic.Dictionary<string, FirestoreChangeListener> likeListeners = new System.Collections.Generic.Dictionary<string, FirestoreChangeListener>();
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

        var listener = document.Listen(snapshot =>
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

        GD.Print("Listening to friendships...");
        var friendsCollection = conf.db.Collection("friendships");
        friendsCollection
            .WhereArrayContains("participants", conf.userId)
            .Listen(snapshot =>
        {
            GD.Print("Friendships data changed.");
            var content = new Godot.Collections.Array<Godot.Collections.Dictionary<string, Variant>>(snapshot
                .ToArray()
                .Select(element =>
                {
                    var dic = element.ToDictionary();
                    dic.Add("id", element.Id);
                    return DictionaryConverter.ConvertToGodotDictionary(dic);
                }));

            CallDeferred("EmitFriendshipsChanged", content);
        });

        GD.Print("Listening to sessions...");
        var sessionsCollection = conf.db.Collection("sessions");
        sessionsCollection
            .WhereArrayContains("participants", conf.userId)
            .Listen(snapshot =>
        {
            GD.Print("Sessions data changed.");
            var content = new Godot.Collections.Array<Godot.Collections.Dictionary<string, Variant>>(snapshot
                .ToArray()
                .Select(element =>
                {
                    var dic = element.ToDictionary();
                    dic.Add("id", element.Id);
                    return DictionaryConverter.ConvertToGodotDictionary(dic);
                }));

            CallDeferred("EmitSessionsChanged", content);
        });
    }

    public async void ListenToSession(string sessionId)
    {
        GD.Print("Listening to session " + sessionId + "...");
        var sessionCollection = conf.db.Collection("sessions");
        var document = sessionCollection.Document(sessionId);
        document.Listen(snapshot =>
        {
            GD.Print("Session data changed.");
            if (snapshot.Exists)
            {
                CallDeferred("EmitSessionChanged", DictionaryConverter.ConvertToGodotDictionary(snapshot.ToDictionary()));
            }
            else
            {
                GD.Print("Document does not exist.");
            }
        });

        var sessionLikesCollection = conf.db.Collection("sessions/" + sessionId + "/likes");
        sessionLikesCollection.Listen(snapshot =>
        {
            GD.Print("Likes data changed.");
            snapshot
                .ToList()
                .Where(element => !likeListeners.ContainsKey(element.Id))
                .ToList()
                .ForEach(element => likeListeners.Add(element.Id, listenToLikes(sessionId, element.Id)));
        });
    }

    private FirestoreChangeListener listenToLikes(string sessionId, string gameId)
    {
        GD.Print("Listening to games likes for game " + gameId + "...");
        var likesCollectionName = "sessions/" + sessionId + "/likes/" + gameId;
        var collection = conf.db.Collection(likesCollectionName);
        return collection.Listen(snapshot =>
        {
            var likes = new Godot.Collections.Array<string>();
            snapshot
                .ToList()
                .ForEach(element => likes.Add(element.Id));
            var content = new Dictionary<string, Variant>
            {
                { "id", gameId },
                { "likes", likes }
            };
            CallDeferred("EmitLikesChanged", content);
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

    private void EmitFriendshipsChanged(Variant data)
    {
        EmitSignal("FriendshipsChanged", data);
    }

    private void EmitSessionsChanged(Variant data)
    {
        EmitSignal("SessionsChanged", data);
    }

    private void EmitSessionChanged(Variant data)
    {
        EmitSignal("SessionChanged", data);
    }

    private void EmitLikesChanged(Variant data)
    {
        EmitSignal("LikesChanged", data);
    }
}
