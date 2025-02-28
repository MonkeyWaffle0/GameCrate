class_name CreateSessionFriendInfo
extends Control


signal added(node: CreateSessionFriendInfo)
signal removed(node: CreateSessionFriendInfo)


@onready var add_button: IconButton = %AddButton
@onready var remove_button: IconButton = %RemoveButton
@onready var friend_info: FriendInfo = %FriendInfo

var friendship: Friendship
var is_participant := false:
	set(value):
		is_participant = value
		if add_button and remove_button:
			update_buttons_visibility()


func _ready() -> void:
	if friendship:
		var user_id: String = Firebase.Auth.auth["localid"]
		var other_user_id := friendship.sender if friendship.sender != user_id else friendship.receiver
		friend_info.user_search_data = UserSearchData.new(other_user_id, friendship.other_username)
	update_buttons_visibility()


func update_buttons_visibility() -> void:
	add_button.visible = !is_participant
	remove_button.visible = is_participant


func _on_remove_button_pressed() -> void:
	removed.emit(self)


func _on_add_button_pressed() -> void:
	added.emit(self)
