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
var image_url: String:
	set(value):
		image_url = value
		changed.emit()


func to_dict() -> Dictionary:
	return {
		"id": id,
		"game_name": game_name,
		"year_published": year_published,
		"min_player": min_player,
		"max_player": max_player,
		"playtime": playtime,
		"weight": weight,
		"image_url": image_url,
	}


static func from_dict(dict_data: Dictionary) -> BoardGame:
	var bg := BoardGame.new()
	bg.id = dict_data["id"]
	bg.game_name = dict_data["game_name"]
	bg.year_published = dict_data["year_published"]
	bg.min_player = dict_data["min_player"]
	bg.max_player = dict_data["max_player"]
	bg.playtime = dict_data["playtime"]
	bg.weight = dict_data["weight"]
	bg.image_url = dict_data["image_url"]
	return bg


func _to_string() -> String:
	return "BoardGame: id: %s, name: %s, year published: %s, players: %s-%s, playtime: %s, weight: %s" % [id, game_name, year_published, min_player, max_player, playtime, weight]
