extends Control


@export var board_game_info_search_scene: PackedScene

@onready var game_name: LineEdit = %GameName
@onready var selection_scroll_container: SelectionScrollContainer = %SelectionScrollContainer


func _ready() -> void:
	BggService.search_completed.connect(_on_search_completed)


func _on_search_button_pressed() -> void:
	selection_scroll_container.clear()
	BggService.search_by_name(game_name.text)


func _on_search_completed(result: Array[BoardGame]) -> void:
	for bg in result:
		var board_game_info := board_game_info_search_scene.instantiate()
		board_game_info.board_game = bg
		selection_scroll_container.add_element(board_game_info)
		BggService.fill_game_info(bg)
