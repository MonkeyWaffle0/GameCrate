using Godot;
using Godot.Collections;
using Google.Apis.Auth.OAuth2;
using Google.Cloud.Firestore;

public partial class FireBaseConf : Node
{
    [Signal]
    public delegate void FirebaseConfiguredEventHandler();
    public FirestoreDb db;
    public string userId;

    Node gdFireBase;
    public override async void _Ready()
    {
        gdFireBase = GetNode<Node>("/root/Firebase");
    }

    public void Init(Dictionary auth)
    {
        GD.Print("Initializing real time Firestore updates.");
        Variant accessToken;
        auth.TryGetValue("accesstoken", out accessToken);

        var googleCredential = GoogleCredential.FromAccessToken((string) accessToken);

        db = new FirestoreDbBuilder
        {
            ProjectId = "boardgames-d1e57",
            Credential = googleCredential
        }.Build();
        GD.Print("Real time Firestore updates successfully initialized.");
        EmitSignal("FirebaseConfigured");
    }
}
