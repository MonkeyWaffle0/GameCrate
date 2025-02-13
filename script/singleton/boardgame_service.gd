extends Node


const PLACEHOLDER_ID := "PLACEHOLDER"

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


func show_success_notification() -> void:
	var notification_data := NotificationData.new()
	notification_data.type = NotificationData.NotificationType.SUCCESS
	notification_data.text = "Collection updated!"
	Notifications.add_notification(notification_data)


func show_error_notification() -> void:
	var notification_data := NotificationData.new()
	notification_data.type = NotificationData.NotificationType.ERROR
	notification_data.text = "Error updating collection."
	Notifications.add_notification(notification_data)


func _on_login(auth: Dictionary) -> void:
	var user_id: String = Firebase.Auth.auth["localid"]
	var game_collection_name := "%s/%s/%s" % [AppData.USER_COLLECTION, user_id, AppData.GAME_COLLECTION]
	game_collection = Firebase.Firestore.collection(game_collection_name)
	game_collection.update_doc_error.connect(show_error_notification)
	game_collection.get_doc_error.connect(show_error_notification)
	game_collection.update_doc_success.connect(show_success_notification)
	var placeholder_bg := BoardGame.new()
	placeholder_bg.id = PLACEHOLDER_ID
	await add_game(placeholder_bg)
	FireBaseConf.Init(auth)


func _on_games_changed(data: Array[Dictionary]) -> void:
	data = data.filter(func(bg_data: Dictionary): return bg_data["id"] != PLACEHOLDER_ID)
	var games_owned: Array[BoardGame] = []
	for game_data: Dictionary in data:
		games_owned.append(BoardGame.from_dict(game_data))
	AppData.user_data.games_owned = games_owned
