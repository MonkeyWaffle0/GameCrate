class_name AddFriends
extends StateMachineComponent


@export var add_friend_info_scene: PackedScene

@onready var search_result_container: SelectionScrollContainer = %SearchResultContainer


func _on_search_requested(value: String) -> void:
	if len(value) < 3:
		return
	var users := await UserService.find_users_by_username(value)
	fill(users)


func fill(users: Array[UserSearchData]) -> void:
	search_result_container.clear()
	for user: UserSearchData in users:
		var add_friend_info := add_friend_info_scene.instantiate()
		add_friend_info.user_search_data = user
		search_result_container.add_element(add_friend_info)
