class_name SessionDetails
extends Control


@export var session_details_game_info_scene: PackedScene

@onready var selection_scroll_container: SelectionScrollContainer = %SelectionScrollContainer


func fill() -> void:
	selection_scroll_container.clear()
	var games := await SessionService.get_games(AppData.current_session)
	for game: BoardGame in games:
		var session_details_game_info := session_details_game_info_scene.instantiate() as SessionDetailsGameInfo
		session_details_game_info.board_game = game
		selection_scroll_container.add_element(session_details_game_info)
