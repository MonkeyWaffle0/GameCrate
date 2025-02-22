extends Node


var game_collection: FirestoreCollection


func _ready() -> void:
	Firebase.Auth.login_succeeded.connect(_on_login)
	RealTimeUserService.GamesOwnedChanged.connect(_on_games_changed)


func add_game(board_game: BoardGame) -> void:
	await game_collection.add(board_game.id, board_game.to_dict())


func remove_game(board_game: BoardGame) -> void:
	var game_document := await game_collection.get_doc(board_game.id)
	if game_document == null:
		printerr("Error removing game from games owned: Game not in the list. %s" % [board_game])
		return
	await game_collection.delete(game_document)


func connect_signals() -> void:
	game_collection.update_doc_error.connect(_show_error_notification)
	game_collection.get_doc_error.connect(_show_error_notification)
	game_collection.update_doc_success.connect(_show_success_notification)


func _on_login(auth: Dictionary) -> void:
	var user_id: String = Firebase.Auth.auth["localid"]
	var game_collection_name := "%s/%s/%s" % [AppData.USER_COLLECTION, user_id, AppData.GAME_COLLECTION]
	game_collection = Firebase.Firestore.collection(game_collection_name)
	connect_signals()


func _on_games_changed(data: Array[Dictionary]) -> void:
	var games_owned: Array[BoardGame] = []
	for game_data: Dictionary in data:
		games_owned.append(BoardGame.from_dict(game_data))
	AppData.user_data.games_owned = games_owned


func _show_success_notification() -> void:
	var notification_data := NotificationData.new()
	notification_data.type = NotificationData.NotificationType.SUCCESS
	notification_data.text = "Collection updated!"
	Notifications.add_notification(notification_data)


func _show_error_notification() -> void:
	var notification_data := NotificationData.new()
	notification_data.type = NotificationData.NotificationType.ERROR
	notification_data.text = "Error updating collection."
	Notifications.add_notification(notification_data)
