
using Godot;
using Godot.Collections;
using Google.Cloud.Firestore;


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
        var auth = (Node) gdFireBase.Get("Auth");
        auth.Connect("login_succeeded", Callable.From((Variant args) => OnAuthSucceeded(args)));
    }

    private async void OnAuthSucceeded(Variant arg)
    {
        CollectionReference collection = conf.db.Collection("users");
        var auth = (Node) gdFireBase.Get("Auth");
        var authDict = (Dictionary)auth.Get("auth");
        var userId = (string)authDict["localid"];
        var document = collection.Document(userId);
        DocumentSnapshot snapshot = await document.GetSnapshotAsync();
        FirestoreChangeListener listener = document.Listen(snapshot =>
        {
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
