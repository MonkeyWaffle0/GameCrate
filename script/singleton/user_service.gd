extends Node


const USERNAME_FIELD := "username"

var user_collection: FirestoreCollection


func _ready() -> void:
	Firebase.Auth.login_succeeded.connect(_on_login)
	RealTimeUserService.UserDataChanged.connect(_on_user_data_changed)


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


func get_all_users() -> Array[UserData]:
	var query := FirestoreQuery.new()
	query.from(AppData.USER_COLLECTION)
	var users: Array = await Firebase.Firestore.query(query)
	var result: Array[UserData] = []
	for user_doc in users:
		result.append(UserData.from_dict(user_doc.get_unsafe_document()))
	return result


func find_user_by_id(user_id: String) -> UserSearchData:
	var user_document = await user_collection.get_doc(user_id)
	if user_document == null:
		return null
	var data_dict := user_document.get_unsafe_document()
	data_dict["id"] = user_document.doc_name
	return UserSearchData.from_dict(data_dict)


func find_user_by_username(username: String) -> UserSearchData:
	var query := FirestoreQuery.new()
	query.from(AppData.USER_COLLECTION, false)
	var users: Array = await Firebase.Firestore.query(query)

	for user: FirestoreDocument in users:
		var doc := user.get_unsafe_document()
		if username.to_lower() == doc["username"].to_lower():
			doc["id"] = doc.doc_name
			return UserSearchData.from_dict(doc)
	return null


### Fetch all users and returns an Array[UserSearchData] that contains every user where the username
### param is contained in their username
func find_users_by_username(username: String) -> Array[UserSearchData]:
	var query := FirestoreQuery.new()
	query.from(AppData.USER_COLLECTION, false)
	var users: Array = await Firebase.Firestore.query(query)
	var result: Array[UserSearchData] = []
	for user: FirestoreDocument in users:
		var doc := user.get_unsafe_document()
		if username.to_lower() in doc["username"].to_lower():
			result.append(UserSearchData.new(user.doc_name, doc["username"]))
	return result


func is_username_available(username: String) -> bool:
	return await find_user_by_username(username) == null


func _on_login(auth: Dictionary) -> void:
	var user_id: String = Firebase.Auth.auth["localid"]
	user_collection = Firebase.Firestore.collection(AppData.USER_COLLECTION)
	var user_document = await user_collection.get_doc(user_id)
	if user_document == null:
		var data = {USERNAME_FIELD: ""}
		await user_collection.add(user_id, data)


func _on_user_data_changed(data: Dictionary) -> void:
	AppData.user_data.username = data["username"]
