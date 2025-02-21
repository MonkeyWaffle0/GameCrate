class_name Friends
extends Control


signal add_friends_pressed


func _on_add_friend_button_pressed() -> void:
	add_friends_pressed.emit()
