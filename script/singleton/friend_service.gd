extends Node


const ERROR_MESSAGE := "Error, try again later"

var user_collection: FirestoreCollection


func _ready() -> void:
	Firebase.Auth.login_succeeded.connect(_on_login)
	RealTimeUserService.FriendsChanged.connect(_on_friends_changed)
	RealTimeUserService.FriendsReceivedChanged.connect(_on_friends_received_changed)
	RealTimeUserService.FriendsSentChanged.connect(_on_friends_sent_changed)


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
	return await is_friend(user) or await is_friend_request_sent(user)


func is_friend(user: UserSearchData) -> bool:
	var user_id: String = Firebase.Auth.auth["localid"]
	var friends_collection_name := "%s/%s/%s" % [AppData.USER_COLLECTION, user.id, AppData.FRIEND_COLLECTION]
	var friends_collection := Firebase.Firestore.collection(friends_collection_name)
	var friend_doc := await friends_collection.get_doc(user_id)
	return friend_doc != null


func is_friend_request_sent(user: UserSearchData) -> bool:
	var user_id: String = Firebase.Auth.auth["localid"]
	var received_ok := false
	var sent_ok := false

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

## Deletes the request received by another user, and deletes the sent request of the other user.
## If the deletion of the received request is a success but not the other, will add back the received request.
func delete_received(user: UserSearchData) -> bool:
	var user_id: String = Firebase.Auth.auth["localid"]
	var received_collection_name := "%s/%s/%s" % [AppData.USER_COLLECTION, user_id, AppData.FRIEND_RECEIVED_COLLECTION]
	var received_collection := Firebase.Firestore.collection(received_collection_name)
	var received_doc := await received_collection.get_doc(user.id)
	if not received_doc:
		printerr("Could not delete received friend request, document not found.")
		return false
	var success := await received_collection.delete(received_doc)
	if not success:
		show_error_notification()
		return false

	var sent_collection_name := "%s/%s/%s" % [AppData.USER_COLLECTION, user.id, AppData.FRIEND_SENT_COLLECTION]
	var sent_collection := Firebase.Firestore.collection(sent_collection_name)
	var sent_doc := await sent_collection.get_doc(user_id)
	if not sent_doc:
		printerr("Could not delete sent friend request, document not found.")
		return false
	success = await sent_collection.delete(sent_doc)
	if not success:
		show_error_notification()
		await received_collection.add(user.id, {"username": user.username})
		return false
	return true


## Deletes the sent received to another user, and deletes the received request of the other user.
## If the deletion of the sent  request is a success but not the other, will add back the sent request.
func delete_sent(user: UserSearchData) -> bool:
	var user_id: String = Firebase.Auth.auth["localid"]
	var sent_collection_name := "%s/%s/%s" % [AppData.USER_COLLECTION, user_id, AppData.FRIEND_SENT_COLLECTION]
	var sent_collection := Firebase.Firestore.collection(sent_collection_name)
	var sent_doc := await sent_collection.get_doc(user.id)
	if not sent_doc:
		printerr("Could not delete sent friend request, document not found.")
		return false
	var success := await sent_collection.delete(sent_doc)
	if not success:
		show_error_notification()
		return false

	var received_collection_name := "%s/%s/%s" % [AppData.USER_COLLECTION, user.id, AppData.FRIEND_RECEIVED_COLLECTION]
	var received_collection := Firebase.Firestore.collection(received_collection_name)
	var received_doc := await received_collection.get_doc(user_id)
	if not received_doc:
		printerr("Could not delete received friend request, document not found.")
		return false
	success = await received_collection.delete(received_doc)
	if not success:
		show_error_notification()
		sent_collection.add(user_id, {"username": user.id})
		return false
	return true


## Deletes a friend for the user and the other user.
## If the deletion of the current user is a success but not the other, will add back the friend.
func delete_friend(user: UserSearchData) -> bool:
	var user_id: String = Firebase.Auth.auth["localid"]
	var user_friend_collection_name := "%s/%s/%s" % [AppData.USER_COLLECTION, user_id, AppData.FRIEND_COLLECTION]
	var user_friend_collection := Firebase.Firestore.collection(user_friend_collection_name)
	var user_friend_doc := await user_friend_collection.get_doc(user.id)
	if not user_friend_doc:
		printerr("Could not delete friend of current user, document not found.")
		return false
	var success := await user_friend_collection.delete(user_friend_doc)
	if not success:
		show_error_notification()
		return false

	var other_user_collection_name := "%s/%s/%s" % [AppData.USER_COLLECTION, user.id, AppData.FRIEND_COLLECTION]
	var other_user_collection := Firebase.Firestore.collection(other_user_collection_name)
	var other_user_doc := await other_user_collection.get_doc(user_id)
	if not other_user_doc:
		printerr("Could not delete friend of other user, document not found.")
		return false
	success = await other_user_collection.delete(other_user_doc)
	if not success:
		show_error_notification()
		user_collection.add(user_id, {"username": user.id})
		return false
	return true


## Deletes the received request for the user and the sent request for the other user.
## Adds a friend
func accept_friend(user: UserSearchData) -> bool:
	var success = await delete_received(user)
	if not success:
		return false

	var user_id: String = Firebase.Auth.auth["localid"]
	var user_friend_collection_name := "%s/%s/%s" % [AppData.USER_COLLECTION, user_id, AppData.FRIEND_COLLECTION]
	var user_friend_collection := Firebase.Firestore.collection(user_friend_collection_name)
	var response := await user_friend_collection.add(user.id, {"username": user.username})
	if not response or (response and len(response.errors) > 0):
		show_error_notification()
		return false

	var other_user_collection_name := "%s/%s/%s" % [AppData.USER_COLLECTION, user.id, AppData.FRIEND_COLLECTION]
	var other_user_collection := Firebase.Firestore.collection(other_user_collection_name)
	response = await other_user_collection.add(user_id, {"username": AppData.user_data.username})
	if not response or (response and len(response.errors) > 0):
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


func _on_friends_changed(data: Array[Dictionary]) -> void:
	var friends: Array[UserSearchData] = []
	for friend: Dictionary in data:
		friends.append(UserSearchData.from_dict(friend))
	AppData.user_data.friends = friends


func _on_friends_received_changed(data: Array[Dictionary]) -> void:
	var friends_received: Array[UserSearchData] = []
	for friend: Dictionary in data:
		friends_received.append(UserSearchData.from_dict(friend))
	AppData.user_data.friends_received = friends_received


func _on_friends_sent_changed(data: Array[Dictionary]) -> void:
	var friends_sent: Array[UserSearchData] = []
	for friend: Dictionary in data:
		friends_sent.append(UserSearchData.from_dict(friend))
	AppData.user_data.friends_sent = friends_sent
