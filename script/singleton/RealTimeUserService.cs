
using Godot;
using Godot.Collections;
using Google.Cloud.Firestore;
using System;


public partial class RealTimeUserService : Node
{
    [Signal]
    public delegate void UserDataChangedEventHandler(Dictionary newData);

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
        GD.Print("OnFirebaseConfigured");
        CollectionReference collection = conf.db.Collection("users");
        var auth = (Node)gdFireBase.Get("Auth");
        var authDict = (Dictionary)auth.Get("auth");
        var userId = (string)authDict["localid"];
        var document = collection.Document(userId);
        try
        {
            DocumentSnapshot snapshot = await document.GetSnapshotAsync();
            GD.Print("Got snapshot successfully.");
        }
        catch (Exception e)
        {
            GD.PrintErr("Firestore error: ", e.ToString());
        }
        GD.Print("snapshot ok");
        FirestoreChangeListener listener = document.Listen(snapshot =>
        {
            GD.Print("inside snapshot");
            if (snapshot.Exists)
            {
                CallDeferred("Emit", DictionaryConverter.ConvertToGodotDictionary(snapshot.ToDictionary()));
            }
            else
            {
                GD.Print("Document does not exist.");
            }
        });
    }

    private void Emit(Dictionary<string, Variant> dict)
    {
        EmitSignal("UserDataChanged", dict);
    }
}
