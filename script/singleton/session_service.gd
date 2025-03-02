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


func get_games(session: Session) -> Array[BoardGame]:
	var games: Dictionary[String, BoardGame] = {}
	for participant: String in session.participants:
		var collection_name := "%s/%s/%s" % [AppData.USER_COLLECTION, participant, AppData.GAME_COLLECTION]
		var query := FirestoreQuery.new()
		query.from(collection_name)
		var participant_games: Array[FirestoreDocument] = await Firebase.Firestore.query(query)
		for paritcipant_game_doc: FirestoreDocument in participant_games:
			var bg := BoardGame.from_dict(paritcipant_game_doc.get_unsafe_document())
			games[bg.id] = bg
	return games.values()


func listen_to_session(session_id: String) -> void:
	RealTimeUserService.ListenToSession(session_id)
	RealTimeUserService.LikesChanged.connect(_on_likes_changed)


func _on_likes_changed(data: Dictionary) -> void:
	AppData.current_session.likes[data["id"]] = data["likes"]
	AppData.current_session.likes_changed.emit()


func show_error_notification() -> void:
	var notification_data := NotificationData.new()
	notification_data.type = NotificationData.NotificationType.ERROR
	notification_data.text = ERROR_MESSAGE
	Notifications.add_notification(notification_data)


func _on_login(auth: Dictionary) -> void:
	session_collection = Firebase.Firestore.collection(AppData.SESSION_COLLECTION)
