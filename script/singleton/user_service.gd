extends Node


const USERNAME_FIELD := "username"

var user_collection: FirestoreCollection
var username_cache: Dictionary[String, String] = {}


func _ready() -> void:
	Firebase.Auth.login_succeeded.connect(_on_login)
	RealTimeService.UserDataChanged.connect(_on_user_data_changed)


func save_username(username: String) -> void:
	var user_id: String = AppData.get_user_id()
	var user_document = await user_collection.get_doc(user_id)
	user_document.add_or_update_field(USERNAME_FIELD, username)
	await user_collection.update(user_document)


## Returns true if the user exists in the database but doesn't have a username yet.
func is_first_login() -> bool:
	if "localid" not in Firebase.Auth.auth:
		printerr("Error checking if first login. User is not authenticated.")
		return false

	var user_id: String = AppData.get_user_id()
	var user_document = await user_collection.get_doc(user_id)
	return user_document.get_value("username") == ""


## Retrieve the current user data from the database.
func get_user_data() -> UserData:
	if "localid" not in Firebase.Auth.auth:
		printerr("Error getting user data. User is not authenticated.")
		return

	var user_id: String = AppData.get_user_id()
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


### Fetch all users and returns an Array[UserSearchData] that contains every users where the username
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


## Look in the username_cache to see if we already memoized the username for this user_id.
## If it's not, fetch the user data from the database and save the result in the username_cache.
func get_user_username(user_id: String) -> String:
	if user_id in username_cache:
		return username_cache[user_id]
	else:
		var user_search_data := await find_user_by_id(user_id)
		username_cache[user_id] = user_search_data.username
		return user_search_data.username


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
