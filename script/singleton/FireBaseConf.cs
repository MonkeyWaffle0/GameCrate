using Godot;
using Godot.Collections;
using Google.Apis.Auth.OAuth2;
using Google.Cloud.Firestore;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Security.Cryptography.X509Certificates;
using static CredentialUtil;

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
        var auth = (Node)gdFireBase.Get("Auth");
        auth.Connect("login_succeeded", Callable.From((Dictionary args) => OnAuthSucceeded(args)));
    }

    private async void OnAuthSucceeded(Dictionary auth)
    {
        //var idtoken = new Variant();
        //auth.TryGetValue("idtoken", out idtoken);
        //var httpClient = new System.Net.Http.HttpClient();
        //var functionUrl = "https://us-central1-boardgames-d1e57.cloudfunctions.net/getServiceAccountKey";
        //httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", (string)idtoken);
        //var response = await httpClient.GetAsync(functionUrl);
        //var bytes = await response.Content.ReadAsByteArrayAsync();

        //using var file = FileAccess.Open("res://firebase.json", FileAccess.ModeFlags.Read);
        //string jsonString = file.GetAsText();
        //var jsonData = JsonConvert.DeserializeObject<System.Collections.Generic.Dictionary<string, object>>(jsonString);

        //string clientEmail = (string)jsonData["client_email"];
        //string privateKey = (string)jsonData["private_key"];  // PEM-encoded
        //string tokenUri = (string)jsonData["token_uri"];      // usually https://oauth2.googleapis.com/token
        //string projectId = (string)jsonData["project_id"];

        //var credential = new BouncyCastleServiceAccountCredential(
        //        clientEmail,
        //        privateKey,
        //        tokenUri,
        //        new string[] { "https://www.googleapis.com/auth/datastore" }
        //);

        GD.Print("from access token");

        Variant accessToken;
        auth.TryGetValue("accesstoken", out accessToken);

        var googleCredential = GoogleCredential.FromAccessToken((string)accessToken);

        GD.Print("after access token");

        //var x = GoogleCredential.from();
        //var certificate = new X509Certificate2(bytes, "notasecret");
        //var credential = new ServiceAccountCredential(
        //new ServiceAccountCredential.Initializer("firebase-adminsdk-hkila@boardgames-d1e57.iam.gserviceaccount.com")
        //    {
        //        Scopes = new[] { "https://www.googleapis.com/auth/datastore" }
        //    }.FromCertificate(certificate)
        //);
        db = new FirestoreDbBuilder
        {
            ProjectId = "boardgames-d1e57",
            Credential = googleCredential
        }.Build();

        GD.Print("after db init");

        EmitSignal("FirebaseConfigured");
    }
}
