class_name UserData
extends Resource


signal games_owned_changed
signal friends_changed

var username: String
var games_owned: Array[BoardGame] = []:
	set(value):
		games_owned = value
		games_owned_changed.emit()
var friends: Array[String] = []:
	set(value):
		friends = value
		friends_changed.emit()


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
		var friends = dict_data["friends"]
		for friend in friends:
			user_data.friends.append(friend)
	return user_data
