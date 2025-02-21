class_name AddFriendInfo
extends ScrollElement


@onready var friend_info: FriendInfo = %FriendInfo

var user_search_data: UserSearchData:
	set(value):
		user_search_data = value
		if friend_info:
			friend_info.user_search_data = user_search_data


func _ready() -> void:
	if user_search_data:
		friend_info.user_search_data = user_search_data
