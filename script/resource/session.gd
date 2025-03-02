class_name Session
extends Resource


signal likes_changed

var id : String
var owner: String
var participants: Array[String]
var date: String
var likes: Dictionary


func _init(_id: String, _owner: String, _participants: Array[String], _date: String) -> void:
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


static func from_dict(data: Dictionary) -> Session:
	return Session.new(data["id"], data["owner"], data["participants"], data["date"])
