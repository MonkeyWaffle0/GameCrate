class_name Friends
extends Control


signal add_friends_pressed

@onready var scroll_container: SelectionScrollContainer = %ScrollContainer


func update_friends(friends: Array[UserSearchData]) -> void:
	for friend: UserSearchData in friends:
		pass


func _on_add_friend_button_pressed() -> void:
	add_friends_pressed.emit()
