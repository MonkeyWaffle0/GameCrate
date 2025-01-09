extends Node


signal search_completed(result: Array[BoardGame])
signal search_failed(status_code: int)


func search_by_name(game_name: String) -> void:
	var search_request = SearchRequest.new()
	add_child(search_request)
	search_request.completed.connect(func(result: Array[BoardGame]): _on_search_request_completed(result, game_name))
	search_request.failed.connect(_on_search_request_failed)
	search_request.search_by_name(game_name)


func fill_game_info(board_game: BoardGame) -> void:
	var game_request := GameRequest.new()
	add_child(game_request)
	game_request.get_by_id(board_game.id)
	game_request.completed.connect(func(game_dto: GameDto): _on_game_request_completed(game_dto, board_game))


func _on_search_request_completed(result: Array[BoardGame], game_name: String) -> void:
	BoardGameUtil.sort(result, game_name)
	search_completed.emit(result)


func _on_search_request_failed(status_code: int) -> void:
	print("failed with status " + str(status_code))
	search_failed.emit(status_code)


func _on_game_request_completed(game_dto: GameDto, board_game: BoardGame) -> void:
	board_game.min_player = game_dto.min_player
	board_game.max_player = game_dto.max_player
	board_game.weight = game_dto.weight
	board_game.playtime = game_dto.playtime
	board_game.image_url = game_dto.image_url
