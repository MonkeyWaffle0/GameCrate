class_name ScrollElementWithButton
extends ScrollElement


@export var buttons: Control
@export var buttons_width: int

@onready var board_game_info: BoardGameInfo = %BoardGameInfo

var tween: Tween
var initial_x: int
var board_game: BoardGame
var has_been_initialized := false


func _ready() -> void:
	super._ready()
	if board_game:
		board_game_info.board_game = board_game
	has_been_initialized = true
	initial_x = buttons.position.x
	buttons.position.x += buttons_width


func set_selected(value: bool) -> void:
	if value and not is_selected:
		slide_in()
	elif not value and is_selected:
		slide_out()
	is_selected = value


func slide_in() -> void:
	reset_tween()
	tween.tween_property(buttons, "position:x", initial_x, 0.2)


func slide_out() -> void:
	reset_tween()
	tween.tween_property(buttons, "position:x", initial_x + buttons_width, 0.2)


func reset_tween() -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
