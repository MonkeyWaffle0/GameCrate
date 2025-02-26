class_name AddFriendInfo
extends ScrollElement


@onready var friend_info: FriendInfo = %FriendInfo
@onready var check_mark: MarginContainer = %CheckMark
@onready var spinner: MarginContainer = %Spinner
@onready var add_button: IconButton = $AddButton

var user_search_data: UserSearchData:
	set(value):
		user_search_data = value
		if friend_info:
			friend_info.user_search_data = user_search_data


func _ready() -> void:
	if user_search_data:
		friend_info.user_search_data = user_search_data
		update_status()


func update_status() -> void:
	add_button.hide()
	check_mark.hide()
	spinner.show()
	var is_friend_or_request_sent := await FriendService.is_friend_or_request_sent(user_search_data)
	spinner.hide()
	if is_friend_or_request_sent:
		check_mark.show()
	else:
		add_button.show()


func _on_add_button_pressed() -> void:
	spinner.show()
	add_button.hide()
	var success := await FriendService.create_friendship(user_search_data)
	spinner.hide()
	if success:
		check_mark.show()
	else:
		add_button.show()
