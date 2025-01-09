class_name SearchRequest
extends HTTPRequest


signal completed(response: Array[BoardGame])
signal failed(status_code: int)

const SEARCH_URL := "https://boardgamegeek.com/xmlapi2/search?query=%s&type=boardgame"


func _ready() -> void:
	request_completed.connect(_http_request_completed)


func search_by_name(game_name: String) -> void:
	var error = request(SEARCH_URL % [game_name.uri_encode()])
	if error != OK:
		printerr("An error occurred in the HTTP request search_by_name.")


func _http_request_completed(_result, response_code: int, _headers, body: PackedByteArray) -> void:
	if response_code != 200:
		failed.emit(response_code)
		queue_free()
		return

	var parser := XMLParser.new()
	parser.open_buffer(body)
	var result : Array[BoardGame] = []
	var current_game := BoardGame.new()
	while parser.read() != ERR_FILE_EOF:
		if parser.get_node_type() == XMLParser.NODE_ELEMENT:
			var node_name = parser.get_node_name()
			var attributes_dict = {}
			for idx in range(parser.get_attribute_count()):
				attributes_dict[parser.get_attribute_name(idx)] = parser.get_attribute_value(idx)
			if node_name == "item":
				current_game.id = attributes_dict["id"]
			elif node_name == "name":
				current_game.game_name = attributes_dict["value"]
			elif node_name == "yearpublished":
				current_game.year_published = attributes_dict["value"]
				result.append(current_game)
				if len(result) == 20:
					break
				current_game = BoardGame.new()
	completed.emit(result)
	queue_free()
