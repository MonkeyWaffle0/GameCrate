using Godot;
using Google.Apis.Auth.OAuth2;
using Google.Cloud.Firestore;
using Grpc.Core;
using System.IO;

public partial class FireBaseConf : Node
{
    public FirestoreDb db;
    public string userId;

    public override async void _Ready()
    {
        using var file = Godot.FileAccess.Open("res://firebase.json", Godot.FileAccess.ModeFlags.Read);
        string content = file.GetAsText();
        var credential = GoogleCredential.FromJson(content);
        db = new FirestoreDbBuilder
        {
            ProjectId = "boardgames-d1e57",
            Credential = credential
        }.Build();
    }
}
