class_name BoardGameInfoSearch
extends Control


@onready var add_button: IconButton = %AddButton
@onready var board_game_info: BoardGameInfo = %BoardGameInfo

var is_selected := false
var tween: Tween
var initial_x: int
var board_game: BoardGame


func _ready() -> void:
	initial_x = add_button.position.x
	add_button.position.x += 200
	if board_game:
		board_game_info.board_game = board_game


func _on_add_button_pressed() -> void:
	add_button.enable(false)
	UserService.add_game(board_game)


func _on_button_pressed() -> void:
	is_selected = not is_selected
	if is_selected:
		slide_in()
	else:
		slide_out()


func slide_in() -> void:
	reset_tween()
	tween.tween_property(add_button, "position:x", initial_x, 0.2)


func slide_out() -> void:
	reset_tween()
	tween.tween_property(add_button, "position:x", initial_x + 200, 0.2)


func reset_tween() -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
