class_name UserData
extends Resource


signal games_owned_changed
signal friendships_changed
signal sessions_changed

var username: String
var games_owned: Array[BoardGame] = []:
	set(value):
		games_owned = value
		games_owned_changed.emit()
var friendships: Array[Friendship] = []:
	set(value):
		friendships = value
		friendships_changed.emit()
var sessions: Array[Session] = []


func get_frienship(id: String) -> Friendship:
	for friendship: Friendship in friendships:
		if friendship.id == id:
			return friendship
	return null


func get_session(id: String) -> Session:
	for session: Session in sessions:
		if session.id == id:
			return session
	return null


## Returns the list of Friendship with the status ACCEPTED sorted with other_username in Alphabetical order
func get_friends() -> Array[Friendship]:
	var result := friendships \
	.filter(func(friendship: Friendship) -> bool: return friendship.status == Friendship.Status.ACCEPTED)
	result.sort_custom(_sort_by_other_username)
	return result


func _sort_by_other_username(a: Friendship, b: Friendship) -> bool:
	if a.other_username < b.other_username:
		return true
	return false


func to_dict() -> Dictionary:
	return {"username": username}


static func from_dict(dict_data: Dictionary) -> UserData:
	var user_data := UserData.new()
	user_data.username = dict_data["username"]
	return user_data
