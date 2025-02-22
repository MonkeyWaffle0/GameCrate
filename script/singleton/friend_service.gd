extends Node


var user_collection: FirestoreCollection


func _ready() -> void:
	Firebase.Auth.login_succeeded.connect(_on_login)


func send_friend_request(user: UserSearchData) -> void:
	var user_id: String = Firebase.Auth.auth["localid"]

	var received_collection_name := "%s/%s/%s" % [AppData.USER_COLLECTION, user.id, AppData.FRIEND_RECEIVED_COLLECTION]
	var received_collection := Firebase.Firestore.collection(received_collection_name)
	received_collection.add(user_id, {"username": AppData.user_data.username})

	var sent_collection_name := "%s/%s/%s" % [AppData.USER_COLLECTION, user_id, AppData.FRIEND_SENT_COLLECTION]
	var sent_collection := Firebase.Firestore.collection(sent_collection_name)
	sent_collection.add(user.id, {"username": user.username})


func _on_login(auth: Dictionary) -> void:
	user_collection = Firebase.Firestore.collection(AppData.USER_COLLECTION)
