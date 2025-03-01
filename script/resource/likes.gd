class_name Likes
extends Resource

# the id of the element that has been liked
var id: String
# The id of every user that liked this element
var likers: Array[String]


func _init(_id: String, _likers: Array[String]) -> void:
	self.id = _id
	self.likers = _likers


func to_dict() -> Dictionary:
	return {
		"likers": likers
	}


static func from_dict(data: Dictionary) -> Likes:
	return Likes.new(data["id"], data["likers"])
