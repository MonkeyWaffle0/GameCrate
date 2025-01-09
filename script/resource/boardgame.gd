class_name BoardGame
extends Resource


var id: String:
	set(value):
		id = value
		changed.emit()
var game_name: String:
	set(value):
		game_name = value
		changed.emit()
var year_published: String:
	set(value):
		year_published = value
		changed.emit()
var min_player: int:
	set(value):
		min_player = value
		changed.emit()
var max_player: int:
	set(value):
		max_player = value
		changed.emit()
var playtime: int:
	set(value):
		playtime = value
		changed.emit()
var weight: float:
	set(value):
		weight = round(value * 100) / 100.0
		changed.emit()


func _to_string() -> String:
	return "BoardGame: id: %s, name: %s, year published: %s, players: %s-%s, playtime: %s, weight: %s" % [id, game_name, year_published, min_player, max_player, playtime, weight]
