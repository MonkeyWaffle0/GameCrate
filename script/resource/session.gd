class_name Session
extends Resource


var id : String
var owner: String
var participants: Array[String]
var date: String
var likes: Array[Likes]


func _init(_id: String, _owner: String, _participants: Array[String], _date: String, _likes: Array[Likes]) -> void:
	self.id = _id
	self.owner = _owner
	self.participants = _participants
	self.date = _date
	self.likes = _likes


func to_dict() -> Dictionary:
	return {
		"owner": owner,
		"participants": participants,
		"date": date
	}


static func from_dict(data: Dictionary) -> Session:
	return Session.new(data["id"], data["owner"], data["participants"], data["date"], data["likes"].map(func(likes_data): return Likes.from_dict(likes_data)))
