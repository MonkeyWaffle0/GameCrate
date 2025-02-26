extends Node


const ERROR_MESSAGE := "Error, try again later"

var friendship_collection: FirestoreCollection


func _ready() -> void:
	Firebase.Auth.login_succeeded.connect(_on_login)
	RealTimeUserService.FriendshipsChanged.connect(_on_friendships_changed)


func create_friendship(other_user: UserSearchData) -> bool:
	var user_id: String = Firebase.Auth.auth["localid"]
	var friendship_id := UUID.random_uuid()
	var friendship := Friendship.new(friendship_id, user_id, other_user.id, Friendship.Status.PENDING)
	var response := await friendship_collection.add(friendship_id, friendship.to_dict())
	if response == null or len(response.errors) > 0:
		printerr("Error creating friendship")
		return false
	return true


func update_friendship_status(id: String, status: Friendship.Status) -> bool:
	var friendship_document := await friendship_collection.get_doc(id)
	if friendship_document == null:
		printerr("Could not update frienship %s status. Document not found" % [id])
		return false
	friendship_document.add_or_update_field("status", Friendship.status_to_string(status))
	var response := await friendship_collection.update(friendship_document)
	if response == null or len(response.errors) > 0:
		printerr("Error updating frienship %s status" % [id])
		return false
	return true


func delete_friendship(id: String) -> bool:
	var frienship_doc := await friendship_collection.get_doc(id)
	if frienship_doc == null:
		printerr("Could not delete friendship %s. Document not found" % [id])
		return false
	var success := await friendship_collection.delete(frienship_doc)
	if not success:
		printerr("Error deleting friendship")
		return false
	return true


func is_friend_or_request_sent(user: UserSearchData) -> bool:
	var user_id: String = Firebase.Auth.auth["localid"]
	var query := FirestoreQuery.new()
	query.from(AppData.FRIENDSHIP_COLLECTION, false).where("participants", FirestoreQuery.OPERATOR.ARRAY_CONTAINS, user_id)
	var frienship_documents: Array = await Firebase.Firestore.query(query)
	for frienship_document: FirestoreDocument in frienship_documents:
		var doc_content := frienship_document.get_unsafe_document()
		if user.id in doc_content["participants"] and (doc_content["status"] == "PENDING" or doc_content["status"] == "ACCEPTED"):
			return true
	return false


func show_error_notification() -> void:
	var notification_data := NotificationData.new()
	notification_data.type = NotificationData.NotificationType.ERROR
	notification_data.text = ERROR_MESSAGE
	Notifications.add_notification(notification_data)


func _on_login(auth: Dictionary) -> void:
	friendship_collection = Firebase.Firestore.collection(AppData.FRIENDSHIP_COLLECTION)


func _on_friendships_changed(data: Array[Dictionary]) -> void:
	var user_data := AppData.user_data
	var friendships: Array[Friendship] = []
	for friendship_data: Dictionary in data:
		var friendship := Friendship.from_dict(friendship_data)
		if friendship.status == Friendship.Status.DELETED or friendship.status == Friendship.Status.REJECTED:
			continue
		friendships.append(Friendship.from_dict(friendship_data))

	for friendship: Friendship in friendships:
		var local_friendship := user_data.get_frienship(friendship.id)
		if local_friendship == null:
			user_data.friendships.append(friendship)
		elif friendship.status != local_friendship.status:
			user_data.friendships.append(friendship)
			user_data.friendships.erase(local_friendship)

	var friendship_ids := friendships.map(func(friendship: Friendship): return friendship.id)
	for friendship: Friendship in user_data.friendships.duplicate():
		if friendship.id not in friendship_ids:
			user_data.friendships.erase(friendship)

	user_data.friendships_changed.emit()
