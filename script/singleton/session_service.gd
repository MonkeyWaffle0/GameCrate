extends Node


const LIKES_COLLECTION_TEMPLATE := AppData.SESSION_COLLECTION + "/%s/" + AppData.LIKES_COLLECTION + "%s"
const ERROR_MESSAGE := "Error, try again later"

var session_collection: FirestoreCollection


func _ready() -> void:
	Firebase.Auth.login_succeeded.connect(_on_login)


func create_session(session: Session) -> bool:
	var session_data := session.to_dict()
	var response := await session_collection.add(session.id, session_data)
	if not response or len(response.errors) > 0:
		printerr("Error creating session")
		show_error_notification()
		return false
	return true


func add_like(session_id: String, game_id: String) -> bool:
	var user_id := AppData.get_user_id()
	var likes_collection_name := LIKES_COLLECTION_TEMPLATE % [session_id, game_id]
	var likes_collection := Firebase.Firestore.collection(likes_collection_name)
	var response := await likes_collection.add(user_id, {"likedAt": Time.get_datetime_string_from_system()})
	if not response or len(response.errors) > 0:
		show_error_notification()
		printerr("Error adding like to session %s, game %s" % [session_id, game_id])
		return false
	return true


func remove_like(session_id: String, game_id: String) -> bool:
	var user_id := AppData.get_user_id()
	var likes_collection_name := LIKES_COLLECTION_TEMPLATE % [session_id, game_id]
	var likes_collection := Firebase.Firestore.collection(likes_collection_name)
	var like_doc := await likes_collection.get_doc(user_id)
	if like_doc == null:
		show_error_notification()
		printerr("Error removing like from session %s, game %s, user id %s, not found" % [session_id, game_id, user_id])
		return false
	var success := await likes_collection.delete(like_doc)
	if not success:
		show_error_notification()
		printerr("Error removing like from session %s, game %s, user id %s" % [session_id, game_id, user_id])
		return false
	return true


func show_error_notification() -> void:
	var notification_data := NotificationData.new()
	notification_data.type = NotificationData.NotificationType.ERROR
	notification_data.text = ERROR_MESSAGE
	Notifications.add_notification(notification_data)


func _on_login(auth: Dictionary) -> void:
	session_collection = Firebase.Firestore.collection(AppData.SESSION_COLLECTION)
