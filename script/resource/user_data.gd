class_name UserData
extends Resource


signal games_owned_changed
signal friendships_changed

var username: String
var games_owned: Array[BoardGame] = []:
	set(value):
		games_owned = value
		games_owned_changed.emit()
var friendships: Array[Friendship] = []:
	set(value):
		friendships = value
		friendships_changed.emit()


func to_dict() -> Dictionary:
	return {"username": username}


static func from_dict(dict_data: Dictionary) -> UserData:
	var user_data := UserData.new()
	user_data.username = dict_data["username"]
	return user_data
