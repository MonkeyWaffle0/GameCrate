extends Node


const LIKES_COLLECTION_TEMPLATE := AppData.SESSION_COLLECTION + "/%s/" + AppData.LIKES_COLLECTION
const ERROR_MESSAGE := "Error, try again later"

var session_collection: FirestoreCollection


func _ready() -> void:
	Firebase.Auth.login_succeeded.connect(_on_login)
	RealTimeService.SessionsChanged.connect(_on_sessions_changed)


func create_session(session: Session) -> bool:
	var session_data := session.to_dict()
	var response := await session_collection.add(session.id, session_data)
	if not response or len(response.errors) > 0:
		printerr("Error creating session")
		show_error_notification()
		return false
	return true


func add_like(session_id: String, like: Like) -> bool:
	var user_id := AppData.get_user_id()
	var likes_collection_name := LIKES_COLLECTION_TEMPLATE % [session_id]
	var likes_collection := Firebase.Firestore.collection(likes_collection_name)
	var response := await likes_collection.add(like.id, like.to_dict())
	if not response or len(response.errors) > 0:
		show_error_notification()
		printerr("Error adding like to session %s, game %s" % [session_id, like.game_id])
		return false
	return true


func remove_like(session_id: String, like: Like) -> bool:
	var user_id := AppData.get_user_id()
	var likes_collection_name := LIKES_COLLECTION_TEMPLATE % [session_id]
	var likes_collection := Firebase.Firestore.collection(likes_collection_name)
	var like_doc := await likes_collection.get_doc(like.id)
	if like_doc == null:
		show_error_notification()
		printerr("Error removing like from session %s, game %s, user id %s, not found" % [session_id, like.game_id, user_id])
		return false
	var success := await likes_collection.delete(like_doc)
	if not success:
		show_error_notification()
		printerr("Error removing like from session %s, game %s, user id %s" % [session_id, like.game_id, user_id])
		return false
	return true


func get_games(session: Session) -> Array[BoardGame]:
	var games: Dictionary[String, BoardGame] = {}
	for participant: String in session.participants:
		var collection_name := "%s/%s/%s" % [AppData.USER_COLLECTION, participant, AppData.GAME_COLLECTION]
		# Hack using the RealTimeUserService because the gdscript firebase plugin does not support query from a non-root collection.
		RealTimeService.GetCollectionDocuments(collection_name)
		RealTimeService.CollectionDocumentsReceived.connect(func(data):
			for game in data:
				var bg := BoardGame.from_dict(game)
				games[bg.id] = bg
			)
		await RealTimeService.CollectionDocumentsReceived
	return games.values()


func listen_to_session(session_id: String) -> void:
	RealTimeService.ListenToSession(session_id)
	RealTimeService.LikesChanged.connect(_on_likes_changed)


func _on_likes_changed(data: Array[Dictionary]) -> void:
	var user_data := AppData.user_data
	var session := AppData.current_session
	var likes: Array[Like] = []
	for like_data: Dictionary in data:
		var like := await Like.from_dict(like_data)
		likes.append(like)

	for like: Like in likes:
		var local_like := session.get_like(like.id)
		if local_like == null:
			session.likes.append(like)
	var like_ids := likes.map(func(like: Like): return like.id)
	for like: Like in session.likes.duplicate():
		if like.id not in like_ids:
			session.likes.erase(like)

	session.likes_changed.emit()


func show_error_notification() -> void:
	var notification_data := NotificationData.new()
	notification_data.type = NotificationData.NotificationType.ERROR
	notification_data.text = ERROR_MESSAGE
	Notifications.add_notification(notification_data)


func _on_login(_auth: Dictionary) -> void:
	session_collection = Firebase.Firestore.collection(AppData.SESSION_COLLECTION)


func _on_sessions_changed(data: Array[Dictionary]) -> void:
	var user_data := AppData.user_data
	var sessions: Array[Session] = []
	for session_data: Dictionary in data:
		var session := await Session.from_dict(session_data)
		sessions.append(session)

	for session: Session in sessions:
		var local_session := user_data.get_session(session.id)
		if local_session == null:
			user_data.sessions.append(session)

	var session_ids := sessions.map(func(session: Session): return session.id)
	for session: Session in user_data.sessions.duplicate():
		if session.id not in session_ids:
			user_data.sessions.erase(session)
	user_data.sessions_changed.emit()
