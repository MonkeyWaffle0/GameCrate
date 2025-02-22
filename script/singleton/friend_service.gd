extends Node


const ERROR_MESSAGE := "Error, try again later"

var user_collection: FirestoreCollection


func _ready() -> void:
	Firebase.Auth.login_succeeded.connect(_on_login)


## Return true is successful, false if an error has occured
func send_friend_request(user: UserSearchData) -> bool:
	var received_success := await add_received(user)
	if not received_success:
		return false

	var sent_success := await add_sent(user)
	if not sent_success:
		await delete_received(user)
		return false
	return true


func is_friend_or_request_sent(user: UserSearchData) -> bool:
	var received_ok := false
	var sent_ok := false

	var user_id: String = Firebase.Auth.auth["localid"]

	var received_collection_name := "%s/%s/%s" % [AppData.USER_COLLECTION, user.id, AppData.FRIEND_RECEIVED_COLLECTION]
	var received_collection := Firebase.Firestore.collection(received_collection_name)
	var received_doc := await received_collection.get_doc(user_id)
	if received_doc:
		received_ok = true

	var sent_collection_name := "%s/%s/%s" % [AppData.USER_COLLECTION, user_id, AppData.FRIEND_SENT_COLLECTION]
	var sent_collection := Firebase.Firestore.collection(sent_collection_name)
	var sent_doc = await sent_collection.get_doc(user.id)
	if sent_doc:
		sent_ok = true

	if received_ok and not sent_ok:
		var success := await add_sent(user)
		if success:
			sent_ok = true
	elif sent_ok and not received_ok:
		var success := await add_received(user)
		if success:
			received_ok = true

	return received_ok and sent_ok


func add_received(user: UserSearchData) -> bool:
	var user_id: String = Firebase.Auth.auth["localid"]
	var received_collection_name := "%s/%s/%s" % [AppData.USER_COLLECTION, user.id, AppData.FRIEND_RECEIVED_COLLECTION]
	var received_collection := Firebase.Firestore.collection(received_collection_name)
	var received_response := await received_collection.add(user_id, {"username": AppData.user_data.username})
	if not received_response or (received_response and len(received_response.errors)):
		show_error_notification()
		return false
	return true


func add_sent(user: UserSearchData) -> bool:
	var user_id: String = Firebase.Auth.auth["localid"]
	var sent_collection_name := "%s/%s/%s" % [AppData.USER_COLLECTION, user_id, AppData.FRIEND_SENT_COLLECTION]
	var sent_collection := Firebase.Firestore.collection(sent_collection_name)
	var sent_response = await sent_collection.add(user.id, {"username": user.username})
	if not sent_response or (sent_response and len(sent_response.errors)):
		show_error_notification()
		return false
	return true


func delete_received(user: UserSearchData) -> bool:
	var user_id: String = Firebase.Auth.auth["localid"]
	var received_collection_name := "%s/%s/%s" % [AppData.USER_COLLECTION, user.id, AppData.FRIEND_RECEIVED_COLLECTION]
	var received_collection := Firebase.Firestore.collection(received_collection_name)
	var received_doc := await received_collection.get_doc(user_id)
	if not received_doc:
		printerr("Could not delete received friend request, document not found.")
		return false
	var success := await received_collection.delete(received_doc)
	if not success:
		show_error_notification()
		return false
	return true


func delete_sent(user: UserSearchData) -> bool:
	var user_id: String = Firebase.Auth.auth["localid"]
	var sent_collection_name := "%s/%s/%s" % [AppData.USER_COLLECTION, user_id, AppData.FRIEND_SENT_COLLECTION]
	var sent_collection := Firebase.Firestore.collection(sent_collection_name)
	var sent_doc := await sent_collection.get_doc(user_id)
	if not sent_doc:
		printerr("Could not delete sent friend request, document not found.")
		return false
	var success := await sent_collection.delete(sent_doc)
	if not success:
		show_error_notification()
		return false
	return true


func show_error_notification() -> void:
	var notification_data := NotificationData.new()
	notification_data.type = NotificationData.NotificationType.ERROR
	notification_data.text = ERROR_MESSAGE
	Notifications.add_notification(notification_data)


func _on_login(auth: Dictionary) -> void:
	user_collection = Firebase.Firestore.collection(AppData.USER_COLLECTION)
