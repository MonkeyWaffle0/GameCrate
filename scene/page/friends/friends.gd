class_name Friends
extends Control


signal add_friends_pressed

@export var action_friend_info_scene: PackedScene

@onready var scroll_container: SelectionScrollContainer = %ScrollContainer


func update_friends(friendships: Array[Friendship]) -> void:
	scroll_container.clear()
	scroll_container.update_subcontainer_visibility()
	var user_id: String = Firebase.Auth.auth["localid"]
	for friendship: Friendship in friendships:
		var action_friend_info := action_friend_info_scene.instantiate() as ActionFriendInfo
		action_friend_info.friendship = friendship
		var other_user_id := friendship.receiver if friendship.receiver != user_id else friendship.sender
		action_friend_info.user_search_data = await UserService.find_user_by_id(other_user_id)
		if friendship.status == Friendship.Status.ACCEPTED:
			scroll_container.add_element(action_friend_info, 0)
		elif is_receiver(friendship, user_id):
			scroll_container.add_element(action_friend_info, 1)
		elif is_sender(friendship, user_id):
			scroll_container.add_element(action_friend_info, 2)
	# Wait for a process frame for the children to have been properly added
	await get_tree().process_frame
	scroll_container.update_subcontainer_visibility()


func _on_add_friend_button_pressed() -> void:
	add_friends_pressed.emit()


func is_sender(friendship: Friendship, user_id: String) -> bool:
	return friendship.sender == user_id


func is_receiver(friendship: Friendship, user_id: String) -> bool:
	return friendship.receiver == user_id
