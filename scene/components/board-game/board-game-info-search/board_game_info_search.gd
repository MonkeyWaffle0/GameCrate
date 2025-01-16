class_name BoardGameInfoSearch
extends ScrollElementWithButton


func _on_add_button_pressed() -> void:
	set_selected(false)
	UserService.add_game(board_game)
