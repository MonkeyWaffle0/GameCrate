class_name BoardGameInfoCollection
extends ScrollElementWithButton


func _on_remove_button_pressed() -> void:
	set_selected(false)
	BoardgameService.remove_game(board_game)
