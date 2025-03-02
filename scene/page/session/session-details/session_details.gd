class_name SessionDetails
extends Control


@onready var selection_scroll_container: SelectionScrollContainer = %SelectionScrollContainer


func fill() -> void:
	selection_scroll_container.clear()
	var games := await SessionService.get_games(AppData.current_session)
