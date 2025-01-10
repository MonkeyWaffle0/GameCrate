extends Node


const USER_COLLECTION := "users"
const GAMES_OWNED_FIELD := "games_owned"

var user_collection: FirestoreCollection


func _ready() -> void:
	Firebase.Auth.login_succeeded.connect(_on_login)
	RealTimeUserService.UserDataChanged.connect(_on_user_data_changed)


func save_game_list(games: Array[BoardGame]) -> void:
	var games_dict := games.map(func(bg: BoardGame): return bg.to_dict())
	if "localid" not in Firebase.Auth.auth:
		printerr("Error saving game list. User is not authenticated.")
		return

	var user_id: String = Firebase.Auth.auth["localid"]
	var user_document = await user_collection.get_doc(user_id)
	if user_document == null:
		var data = {GAMES_OWNED_FIELD: games_dict}
		await user_collection.add(user_id, data)
	else:
		user_document.add_or_update_field(GAMES_OWNED_FIELD, games_dict)
		await user_collection.update(user_document)


func add_game(board_game: BoardGame) -> void:
	if len(AppData.user_data.games_owned.filter(func(bg:BoardGame): return bg.id == board_game.id)) > 0:
		printerr("Error adding game from games owned: Game is already in the list. %s" % [board_game])
		return
	AppData.user_data.games_owned.append(board_game)
	save_game_list(AppData.user_data.games_owned)


func remove_game(board_game: BoardGame) -> void:
	if len(AppData.user_data.games_owned.filter(func(bg:BoardGame): return bg.id == board_game.id)) == 0:
		printerr("Error removing game from games owned: Game not in the list. %s" % [board_game])
		return

	for bg in AppData.user_data.games_owned:
		if bg.id == board_game.id:
			AppData.user_data.games_owned.erase(bg)
			break
	save_game_list(AppData.user_data.games_owned)


func get_user_data() -> UserData:
	if "localid" not in Firebase.Auth.auth:
		printerr("Error saving game list. User is not authenticated.")
		return

	var user_id: String = Firebase.Auth.auth["localid"]
	var user_document = await user_collection.get_doc(user_id)
	var data_dict := user_document.get_unsafe_document()
	return UserData.from_dict(data_dict)


func show_success_notification() -> void:
	var notification_data := NotificationData.new()
	notification_data.type = NotificationData.NotificationType.SUCCESS
	notification_data.text = "Collection updated !"
	Notifications.add_notification(notification_data)


func show_error_notification() -> void:
	var notification_data := NotificationData.new()
	notification_data.type = NotificationData.NotificationType.ERROR
	notification_data.text = "Error updating collection."
	Notifications.add_notification(notification_data)


func _on_login(auth: Dictionary) -> void:
	var user_id: String = Firebase.Auth.auth["localid"]
	user_collection = Firebase.Firestore.collection(USER_COLLECTION)
	user_collection.update_doc_error.connect(show_error_notification)
	user_collection.get_doc_error.connect(show_error_notification)
	user_collection.update_doc_success.connect(show_success_notification)


func _on_user_data_changed(data: Dictionary) -> void:
	AppData.user_data = UserData.from_dict(data)
