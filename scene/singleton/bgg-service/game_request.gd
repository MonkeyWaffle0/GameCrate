class_name GameRequest
extends HTTPRequest


signal completed(response: GameDto)
signal failed(status_code: int)

const URL := "https://boardgamegeek.com/xmlapi2/thing?id=%s&stats=1"


func _ready() -> void:
	request_completed.connect(_http_request_completed)


func get_by_id(id: String) -> void:
	var error = request(URL % [id])
	if error != OK:
		printerr("An error occurred in the HTTP request get_by_id.")


func _http_request_completed(_result, response_code: int, _headers, body: PackedByteArray):
	if response_code != 200:
		failed.emit(response_code)
		queue_free()
		return

	var parser := XMLParser.new()
	parser.open_buffer(body)
	var result = []
	var game := GameDto.new()
	while parser.read() != ERR_FILE_EOF:
		if parser.get_node_type() == XMLParser.NODE_ELEMENT:
			var node_name = parser.get_node_name()
			var attributes_dict = {}
			for idx in range(parser.get_attribute_count()):
				attributes_dict[parser.get_attribute_name(idx)] = parser.get_attribute_value(idx)
			if node_name == "minplayers":
				game.min_player = attributes_dict["value"]
			elif node_name == "maxplayers":
				game.max_player = attributes_dict["value"]
			elif node_name == "playingtime":
				game.playtime = attributes_dict["value"]
			elif node_name == "averageweight":
				game.weight = attributes_dict["value"]
	completed.emit(game)
	queue_free()
