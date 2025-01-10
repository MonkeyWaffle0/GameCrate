extends Control


@export var board_game_info_search_scene: PackedScene

@onready var game_name: LineEdit = %GameName
@onready var search_result_container: VBoxContainer = %SearchResultContainer


func _ready() -> void:
	BggService.search_completed.connect(_on_search_completed)


func _on_search_button_pressed() -> void:
	for child in search_result_container.get_children():
		child.queue_free()
	BggService.search_by_name(game_name.text)


func _on_search_completed(result: Array[BoardGame]) -> void:
	for bg in result:
		var board_game_info := NodeUtil.instance_scene(board_game_info_search_scene, search_result_container) as BoardGameInfoSearch
		board_game_info.board_game = bg
		BggService.fill_game_info(bg)
