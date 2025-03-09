class_name Session
extends Resource


signal likes_changed

var id : String
var owner: String
var participants: Array
var date: String
var likes: Array[Like]
var participants_usernames: Array[String]
var owner_username: String


func _init(_id: String, _owner: String, _participants: Array, _date: String) -> void:
	self.id = _id
	self.owner = _owner
	self.participants = _participants
	self.date = _date


func get_like(like_id: String) -> Like:
	for like: Like in likes:
		if like.id == like_id:
			return like
	return null


## Return a Like with the user id of the current user and the provided game id
func get_like_by_game_id(game_id: String) -> Like:
	for like: Like in likes:
		if like.game_id == game_id and like.user_id == AppData.get_user_id():
			return like
	return null


func is_liked_by_user(game_id: String) -> bool:
	for like: Like in likes:
		if like.game_id == game_id and like.user_id == AppData.get_user_id():
			return true
	return false


func get_like_amount(game_id: String) -> int:
	return len(likes.filter(func(like: Like): return like.game_id == game_id))


func to_dict() -> Dictionary:
	return {
		"owner": owner,
		"participants": participants,
		"date": date
	}

## Create a Session from a dictionnary, and add the usernames of the participant and the owner by searching by id
static func from_dict(data: Dictionary) -> Session:
	var session := Session.new(data["id"], data["owner"], data["participants"], data["date"])
	session.participants_usernames = []
	for participant: String in session.participants:
		var username := await UserService.get_user_username(participant)
		session.participants_usernames.append(username)
		if participant == session.owner:
			session.owner_username = username
	return session


func _to_string() -> String:
	return "<Session> id: %s, date: %s, owner: %s, participants: %s" % [id, date, owner, participants]
