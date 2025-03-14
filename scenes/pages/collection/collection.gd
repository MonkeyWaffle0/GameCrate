class_name Collection
extends StateMachineComponent


@export var board_game_info_collection_scene: PackedScene

@onready var selection_scroll_container: SelectionScrollContainer = %SelectionScrollContainer
@onready var empty_state: VBoxContainer = %EmptyState


func _ready() -> void:
	AppData.user_data.games_owned_changed.connect(_on_collection_changed)


func load_collection() -> void:
	selection_scroll_container.clear()
	var board_games := AppData.user_data.games_owned
	empty_state.visible = board_games.is_empty()
	selection_scroll_container.visible = !board_games.is_empty()
	for bg: BoardGame in board_games:
		var board_game_info_collection := board_game_info_collection_scene.instantiate() as BoardGameInfoCollection
		board_game_info_collection.board_game = bg
		selection_scroll_container.add_element(board_game_info_collection)


func _on_collection_changed() -> void:
	load_collection()
