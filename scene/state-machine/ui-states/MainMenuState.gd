class_name MenuMainMenuState
extends BaseState


@export var main_menu: MainMenu
@export var background: ColorRect
@export var difficulty_selection_state: MenuDifficultySelectionState
@export var ship_selection_state: MenuShipSelectionState


func enter() -> void:
	Signals.pressed_play.connect(_on_pressed_play)
	Signals.pressed_ship_selection.connect(_on_pressed_ship_selection)
	background.show()
	main_menu.show()
	await get_tree().create_timer(0.3).timeout
	main_menu.animate_in()


func exit() -> void:
	Signals.pressed_play.disconnect(_on_pressed_play)
	Signals.pressed_ship_selection.disconnect(_on_pressed_ship_selection)
	await main_menu.animate_out()
	main_menu.hide()


func _on_pressed_play() -> void:
	get_parent().change_state(difficulty_selection_state)


func _on_pressed_ship_selection() -> void:
	get_parent().change_state(ship_selection_state)
