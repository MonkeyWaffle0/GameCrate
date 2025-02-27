class_name Sessions
extends Control


signal create_session_pressed


func _on_create_session_button_pressed() -> void:
	create_session_pressed.emit()
