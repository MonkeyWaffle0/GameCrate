class_name SessionDetailsGameInfo
extends ScrollElement


@export var empty_like_texture: Texture2D
@export var full_like_texture: Texture2D
@export var empty_color: Color
@export var liked_color: Color

@onready var like_amount: Label = %LikeAmount
@onready var like_button: IconButton = %LikeButton
@onready var board_game_info: BoardGameInfo = %BoardGameInfo

var board_game: BoardGame
var is_liked := false:
	set(value):
		is_liked = value
		if like_button and like_amount:
			update_like_ui()


func _ready() -> void:
	board_game_info.board_game = board_game
	AppData.current_session.likes_changed.connect(_on_likes_changed)
	_on_likes_changed()


func _on_like_button_pressed() -> void:
	var session := AppData.current_session
	if is_liked:
		SessionService.remove_like(session.id, session.get_like_by_game_id(board_game.id))
	else:
		var like := Like.new(UUID.random_uuid(), board_game.id, AppData.get_user_id())
		SessionService.add_like(session.id, like)


func _on_likes_changed() -> void:
	var session := AppData.current_session
	var game_id := board_game.id
	is_liked = session.is_liked_by_user(game_id)
	like_amount.text = str(session.get_like_amount(game_id))


func update_like_ui() -> void:
	if is_liked:
		like_button.set_icon(full_like_texture)
		like_amount.add_theme_color_override("font_color", liked_color)
	else:
		like_button.set_icon(empty_like_texture)
		like_amount.add_theme_color_override("font_color", empty_color)
