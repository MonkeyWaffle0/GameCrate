
using System.Linq;
using Godot;
using Google.Cloud.Firestore;


/// <summary>
/// Service that provides real time updates of the Firestore database. Done in C# since it's not supported
/// by the gdscript Firebase plugin.
/// </summary>
public partial class RealTimeService : Node
{
    [Signal]
    public delegate void UserDataChangedEventHandler(Variant newData);
    [Signal]
    public delegate void GamesOwnedChangedEventHandler(Variant newData);
    [Signal]
    public delegate void FriendshipsChangedEventHandler(Variant newData);
    [Signal]
    public delegate void SessionChangedEventHandler(Variant newData);
    [Signal]
    public delegate void LikesChangedEventHandler(Variant newData);
    [Signal]
    public delegate void SessionsChangedEventHandler(Variant newData);
    [Signal]
    public delegate void CollectionDocumentsReceivedEventHandler(Variant newData);

    FireBaseConf conf;
    Node gdFireBase;
    private FirestoreChangeListener sessionListener;
    private FirestoreChangeListener likeListener;

    public override async void _Ready()
    {
        conf = GetNode<FireBaseConf>("/root/FireBaseConf");
        gdFireBase = GetNode<Node>("/root/Firebase");
        conf.Connect("FirebaseConfigured", Callable.From(OnFirebaseConfigured));
    }

    private async void OnFirebaseConfigured()
    {
        ListenToUser();
        ListenToGames();
        ListenToFriendships();
        ListenToSessions();
    }

    public void ListenToSession(string sessionId)
    {
        if (sessionListener != null) {
            sessionListener.StopAsync();
        }
        GD.Print("Listening to session " + sessionId + "...");
        var sessionCollection = conf.db.Collection("sessions");
        var document = sessionCollection.Document(sessionId);
        sessionListener = document.Listen(snapshot =>
        {
            GD.Print("Session data changed.");
            if (snapshot.Exists)
            {
                CallDeferred("Emit", "SessionChanged", DictionaryConverter.ConvertToGodotDictionary(snapshot.ToDictionary()));
            }
            else
            {
                GD.Print("Document does not exist.");
            }
        });

        if (likeListener != null) {
            likeListener.StopAsync();
        }
        var sessionLikesCollection = conf.db.Collection("sessions/" + sessionId + "/likes");
        likeListener = sessionLikesCollection.Listen(snapshot =>
        {
            var content = new Godot.Collections.Array<Godot.Collections.Dictionary<string, Variant>>(snapshot
                .ToArray()
                .Select(element =>
                {
                    var dic = element.ToDictionary();
                    dic.Add("id", element.Id);
                    return DictionaryConverter.ConvertToGodotDictionary(dic);
                }));
            CallDeferred("Emit", "LikesChanged", content);
        });
    }

    public async void GetCollectionDocuments(string collectionId)
    {
        var collectionRef = conf.db.Collection(collectionId);
        var snapshot = await collectionRef.GetSnapshotAsync();
        var content = new Godot.Collections.Array<Godot.Collections.Dictionary<string, Variant>>(snapshot
                .ToArray()
                .Select(element =>
                {
                    var dic = element.ToDictionary();
                    return DictionaryConverter.ConvertToGodotDictionary(dic);
                }));
        EmitSignal("CollectionDocumentsReceived", content);
    }

    // EmitSignal must be wrapped because it can't be called directly with Calldeferred.
    private void Emit(string signalName, Variant data)
    {
        EmitSignal(signalName, data);
    }


    private void ListenToUser()
    {
        GD.Print("Listening to user changes...");
        var userCollection = conf.db.Collection("users");
        var document = userCollection.Document(conf.userId);
        var listener = document.Listen(snapshot =>
        {
            GD.Print("User data changed.");
            if (snapshot.Exists)
            {
                CallDeferred("Emit", "UserDataChanged", DictionaryConverter.ConvertToGodotDictionary(snapshot.ToDictionary()));
            }
            else
            {
                GD.Print("Document does not exist.");
            }
        });
    }

    private void ListenToGames()
    {
        GD.Print("Listening to games changes...");
        var gamesCollection = conf.db.Collection("users/" + conf.userId + "/games");
        gamesCollection.Listen(snapshot =>
        {
            GD.Print("Game collection data changed.");
            var content = new Godot.Collections.Array<Godot.Collections.Dictionary<string, Variant>>(snapshot
                .ToArray()
                .Select(element => DictionaryConverter.ConvertToGodotDictionary(element.ToDictionary())));

            CallDeferred("Emit", "GamesOwnedChanged", content);
        });
    }

    private void ListenToFriendships()
    {
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

            CallDeferred("Emit", "FriendshipsChanged", content);
        });
    }

    private void ListenToSessions()
    {
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

            CallDeferred("Emit", "SessionsChanged", content);
        });
    }
}
