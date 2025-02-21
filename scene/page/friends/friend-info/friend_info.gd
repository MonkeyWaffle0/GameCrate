class_name FriendInfo
extends Control


@onready var friend_username: Label = %FriendUsername

var user_search_data: UserSearchData:
	set(value):
		user_search_data = value
		if friend_username:
			friend_username.text = user_search_data.username


func _ready() -> void:
	if user_search_data:
		friend_username.text = user_search_data.username
