class_name Friends
extends Control


signal add_friends_pressed

@export var action_friend_info_scene: PackedScene

@onready var scroll_container: SelectionScrollContainer = %ScrollContainer


func _on_add_friend_button_pressed() -> void:
	add_friends_pressed.emit()


func is_sender(friendship: Friendship, user_id: String) -> bool:
	return friendship.sender == user_id


func is_receiver(friendship: Friendship, user_id: String) -> bool:
	return friendship.receiver == user_id
