class_name Session
extends Resource


signal likes_changed

var id : String
var owner: String
var participants: Array
var date: String
var likes: Dictionary
var participants_usernames: Array[String]
var owner_username: String


func _init(_id: String, _owner: String, _participants: Array, _date: String) -> void:
	self.id = _id
	self.owner = _owner
	self.participants = _participants
	self.date = _date


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
		var user := await UserService.find_user_by_id(participant)
		session.participants_usernames.append(user.username)
		if participant == session.owner:
			session.owner_username = user.username
	return session
	

func _to_string() -> String:
	return "<Session> id: %s, date: %s, owner: %s, participants: %s" % [id, date, owner, participants]
