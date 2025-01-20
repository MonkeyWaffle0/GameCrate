using Godot;
using Google.Apis.Auth.OAuth2;
using Newtonsoft.Json;
using Org.BouncyCastle.Crypto;
using Org.BouncyCastle.Security;
using System;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Threading;
using Org.BouncyCastle.OpenSsl;

public partial class CredentialUtil : Node
{
    /// <summary>
    /// Custom credential that uses BouncyCastle to sign a service account JWT,
    /// obtains an access token from Google OAuth endpoint, and provides that token to Firestore.
    /// </summary>
    public class BouncyCastleServiceAccountCredential : ITokenAccess
    {
        private readonly string _clientEmail;
        private readonly string _privateKey;  // PEM-encoded private key
        private readonly string _tokenUri;
        private readonly string[] _scopes;

        private string _accessToken;
        private DateTime _tokenExpiry = DateTime.MinValue;

        private static readonly System.Net.Http.HttpClient _httpClient = new System.Net.Http.HttpClient();

        public BouncyCastleServiceAccountCredential(string clientEmail, string privateKey, string tokenUri, string[] scopes)
        {
            _clientEmail = clientEmail;
            _privateKey = privateKey;
            _tokenUri = tokenUri;
            _scopes = scopes;
        }

        /// <summary>
        /// This is called by Google libraries to get the current access token.
        /// If the token is expired (or missing), we fetch a new one.
        /// </summary>
        public async Task<string> GetAccessTokenForRequestAsync(string authUri = null, CancellationToken cancellationToken = default)
        {
            await RequestAccessTokenAsync(cancellationToken);

            return _accessToken;
        }

        /// <summary>
        /// Performs the JWT signing and token request to obtain a new access token.
        /// </summary>
        private async Task RequestAccessTokenAsync(CancellationToken cancellationToken)
        {
            // 1. Create JWT header & payload
            var now = DateTimeOffset.UtcNow.ToUnixTimeSeconds();
            var exp = now + 3600; // 1 hour from now

            string scope = string.Join(" ", _scopes);

            // The JWT header
            var header = new
            {
                alg = "RS256",
                typ = "JWT"
            };

            // The JWT payload
            var payload = new System.Collections.Generic.Dictionary<string, object>()
            {
                { "iss", _clientEmail },
                { "scope", scope },
                { "aud", _tokenUri },
                { "iat", now },
                { "exp", exp }
            };

            string encodedHeader = Base64UrlEncode(Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(header)));
            string encodedPayload = Base64UrlEncode(Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(payload)));

            string signingInput = $"{encodedHeader}.{encodedPayload}";

            // 2. Sign the input with BouncyCastle
            string signature = SignWithBouncyCastle(signingInput, _privateKey);

            // Combine all parts into the final JWT
            string jwt = $"{signingInput}.{signature}";

            // 3. Request the OAuth2 token
            var requestBody = new System.Collections.Generic.Dictionary<string, string>
            {
                {"grant_type", "urn:ietf:params:oauth:grant-type:jwt-bearer" },
                {"assertion", jwt }
            };

            var requestContent = new FormUrlEncodedContent(requestBody);
            var response = await _httpClient.PostAsync(_tokenUri, requestContent, cancellationToken);
            response.EnsureSuccessStatusCode();

            var jsonResponse = await response.Content.ReadAsStringAsync(cancellationToken);
            var tokenResult = JsonConvert.DeserializeObject<TokenResponse>(jsonResponse);

            _accessToken = tokenResult.AccessToken;
            // Calculate new expiry as "now + expires_in" minus a small buffer
            _tokenExpiry = DateTime.UtcNow.AddSeconds(tokenResult.ExpiresIn - 30);
        }

        private static string SignWithBouncyCastle(string signingInput, string privateKeyPem)
        {
            // 1. Parse the PEM private key via BouncyCastle
            AsymmetricKeyParameter privateKeyParameter;
            using (var reader = new System.IO.StringReader(privateKeyPem))
            {
                var pemReader = new PemReader(reader);
                var keyObject = pemReader.ReadObject();
                if (keyObject is AsymmetricCipherKeyPair keyPair)
                {
                    // This block means the PEM contained both public + private keys
                    privateKeyParameter = keyPair.Private;
                }
                else if (keyObject is AsymmetricKeyParameter keyParam)
                {
                    // This block means the PEM only contained a single key param (likely private)
                    if (!keyParam.IsPrivate)
                    {
                        throw new Exception("The key parameter is not a private key.");
                    }
                    privateKeyParameter = keyParam;
                }
                else
                {
                    throw new Exception("Invalid or unsupported key format in PEM.");
                }
            }

            // 2. Create a signer for SHA256withRSA using the private key
            ISigner signer = SignerUtilities.GetSigner("SHA256withRSA");
            signer.Init(true, privateKeyParameter);

            // 3. Sign the data
            byte[] data = System.Text.Encoding.UTF8.GetBytes(signingInput);
            signer.BlockUpdate(data, 0, data.Length);
            byte[] signatureBytes = signer.GenerateSignature();

            // 4. Return base64url-encoded signature
            return Base64UrlEncode(signatureBytes);
        }


        /// <summary>
        /// Base64-url-encode (RFC 4648) without padding, as required for JWT.
        /// </summary>
        private static string Base64UrlEncode(byte[] input)
        {
            var output = Convert.ToBase64String(input)
                .Replace('+', '-')
                .Replace('/', '_')
                .Replace("=", "");
            return output;
        }

        public bool IsAccessTokenExpired()
        {
            return DateTime.UtcNow >= _tokenExpiry.AddSeconds(-60);
        }

        // For convenience in deserializing the token response.
        private class TokenResponse
        {
            [JsonProperty("access_token")]
            public string AccessToken { get; set; }

            [JsonProperty("token_type")]
            public string TokenType { get; set; }

            [JsonProperty("expires_in")]
            public int ExpiresIn { get; set; }
        }
    }
}
