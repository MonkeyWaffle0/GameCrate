class_name Search
extends Control


@export var board_game_info_search_scene: PackedScene

@onready var search_bar: SearchBar = %SearchBar
@onready var selection_scroll_container: SelectionScrollContainer = %SelectionScrollContainer
@onready var empty_state: VBoxContainer = %EmptyState


func _ready() -> void:
	BggService.search_completed.connect(_on_search_completed)


func _on_search_completed(result: Array[BoardGame]) -> void:
	var is_empty := result.is_empty()
	empty_state.visible = is_empty
	selection_scroll_container.visible = !is_empty

	for bg in result:
		var board_game_info := board_game_info_search_scene.instantiate()
		board_game_info.board_game = bg
		selection_scroll_container.add_element(board_game_info)
		BggService.fill_game_info(bg)


func _on_search_requested(value: String) -> void:
	selection_scroll_container.clear()
	BggService.search_by_name(value)
