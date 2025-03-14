class_name Authentication
extends StateMachineComponent


signal signup_pressed
signal login_pressed


func _on_signup_pressed() -> void:
	signup_pressed.emit()


func _on_login_pressed() -> void:
	login_pressed.emit()
