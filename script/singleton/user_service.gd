extends Node


const USERNAME_FIELD := "username"

var user_collection: FirestoreCollection


func _ready() -> void:
	Firebase.Auth.login_succeeded.connect(_on_login)


func save_username(username: String) -> void:
	var user_id: String = Firebase.Auth.auth["localid"]
	var user_document = await user_collection.get_doc(user_id)
	user_document.add_or_update_field(USERNAME_FIELD, username)
	await user_collection.update(user_document)


func is_first_login() -> bool:
	if "localid" not in Firebase.Auth.auth:
		printerr("Error checking if first login. User is not authenticated.")
		return false

	var user_id: String = Firebase.Auth.auth["localid"]
	var user_document = await user_collection.get_doc(user_id)
	return user_document.get_value("username") == ""


func get_user_data() -> UserData:
	if "localid" not in Firebase.Auth.auth:
		printerr("Error getting user data. User is not authenticated.")
		return

	var user_id: String = Firebase.Auth.auth["localid"]
	var user_document = await user_collection.get_doc(user_id)
	if user_document == null:
		return UserData.new()
	var data_dict := user_document.get_unsafe_document()
	return UserData.from_dict(data_dict)


func is_username_available(username: String) -> bool:
	var query := FirestoreQuery.new()
	query.from(AppData.USER_COLLECTION)
	var users: Array = await Firebase.Firestore.query(query)
	var usernames := users.map(func(user_doc): return user_doc.document["username"]["stringValue"].to_lower())
	return username.to_lower() not in usernames


func _on_login(auth: Dictionary) -> void:
	var user_id: String = Firebase.Auth.auth["localid"]
	user_collection = Firebase.Firestore.collection(AppData.USER_COLLECTION)
	var user_document = await user_collection.get_doc(user_id)
	if user_document == null:
		var data = {USERNAME_FIELD: ""}
		await user_collection.add(user_id, data)
