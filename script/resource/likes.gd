class_name Like
extends Resource


var id: String
var game_id: String
var user_id: String


func _init(_id: String, _game_id: String, _user_id: String) -> void:
	self.id = _id
	self.game_id = _game_id
	self.user_id = _user_id


func to_dict() -> Dictionary:
	return {
		"game_id": game_id,
		"user_id": user_id,
	}


static func from_dict(data: Dictionary) -> Like:
	return Like.new(data["id"], data["game_id"], data["user_id"])
