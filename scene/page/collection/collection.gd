class_name Collection
extends Control


@export var board_game_info_collection_scene: PackedScene

@onready var selection_scroll_container: SelectionScrollContainer = %SelectionScrollContainer


func _ready() -> void:
	AppData.user_data.games_owned_changed.connect(_on_collection_changed)


func load_collection() -> void:
	selection_scroll_container.clear()
	for bg: BoardGame in AppData.user_data.games_owned:
		var board_game_info_collection := board_game_info_collection_scene.instantiate() as BoardGameInfoCollection
		board_game_info_collection.board_game = bg
		selection_scroll_container.add_element(board_game_info_collection)


func _on_collection_changed() -> void:
	load_collection()
