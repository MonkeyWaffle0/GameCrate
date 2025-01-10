class_name UserData
extends Resource


var games_owned: Array[BoardGame] = []
var friends: Array[String] = []


func to_dict() -> Dictionary:
	return {
		"games_owned": games_owned.map(func(bg_dict: Dictionary): return BoardGame.from_dict(bg_dict)),
		"friends": friends
	}


static func from_dict(dict_data: Dictionary) -> UserData:
	var user_data := UserData.new()
	if "games_owned" in dict_data:
		var bgs = dict_data["games_owned"].map(func(bg_dict: Dictionary) -> BoardGame: return BoardGame.from_dict(bg_dict))
		for bg in bgs:
			user_data.games_owned.append(bg)
	if "friends" in dict_data:
		user_data.friends = dict_data["friends"]
	return user_data
