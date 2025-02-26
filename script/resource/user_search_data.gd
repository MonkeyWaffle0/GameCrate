class_name UserSearchData
extends Resource


var id: String
var username: String


func _init(_id: String, _username: String) -> void:
	id = _id
	username = _username


func _to_string() -> String:
	return "<UserSearchData> id: %s, username: %s" % [id, username]


static func from_dict(data: Dictionary) -> UserSearchData:
	return UserSearchData.new(data["id"], data["username"])
