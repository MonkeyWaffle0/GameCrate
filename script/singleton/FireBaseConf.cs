using Godot;
using Godot.Collections;
using Google.Apis.Auth.OAuth2;
using Google.Cloud.Firestore;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Security.Cryptography.X509Certificates;

public partial class FireBaseConf : Node
{
    public FirestoreDb db;
    public string userId;

    Node gdFireBase;
    public override async void _Ready()
    {
        gdFireBase = GetNode<Node>("/root/Firebase");
        var auth = (Node)gdFireBase.Get("Auth");
        auth.Connect("login_succeeded", Callable.From((Dictionary args) => OnAuthSucceeded(args)));
    }

    private async void OnAuthSucceeded(Dictionary auth)
    {
        var idtoken = new Variant();
        auth.TryGetValue("idtoken", out idtoken);
        var httpClient = new System.Net.Http.HttpClient();
        var functionUrl = "https://us-central1-boardgames-d1e57.cloudfunctions.net/getServiceAccountKey";
        httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", (string)idtoken);
        var response = await httpClient.GetAsync(functionUrl);
        var keyJson = await response.Content.ReadAsStringAsync();

        GD.Print(keyJson);
        using var file = Godot.FileAccess.Open("res://firebase.p12", Godot.FileAccess.ModeFlags.Read);
        var p12Bytes = file.GetBuffer((long)file.GetLength());
        var certificate = new X509Certificate2(p12Bytes, "notasecret");
        var credential = new ServiceAccountCredential(
        new ServiceAccountCredential.Initializer("firebase-adminsdk-hkila@boardgames-d1e57.iam.gserviceaccount.com")
            {
                Scopes = new[] { "https://www.googleapis.com/auth/datastore" }
            }.FromCertificate(certificate)
        );
        db = new FirestoreDbBuilder
        {
            ProjectId = "boardgames-d1e57",
            Credential = credential
        }.Build();
    }
}
