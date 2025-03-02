class_name SessionDetailsGameInfo
extends Control


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


func _on_like_button_pressed() -> void:
	if is_liked:
		SessionService.remove_like(AppData.current_session.id, board_game.id)
	else:
		SessionService.add_like(AppData.current_session.id, board_game.id)


func _on_likes_changed() -> void:
	var likes := AppData.current_session.likes
	if board_game.id not in likes:
		is_liked = false
		like_amount.text = "0"
	else:
		is_liked = AppData.get_user_id() in likes[board_game.id]
		like_amount.text = str(len(likes[board_game.id]))


func update_like_ui() -> void:
	if is_liked:
		like_button.set_icon(full_like_texture)
		like_amount.add_theme_color_override("front_color", liked_color)
	else:
		like_button.set_icon(empty_like_texture)
		like_amount.add_theme_color_override("front_color", empty_color)
