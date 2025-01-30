class_name Authentication
extends Control


signal signup_pressed
signal login_pressed

const LOGIN_SUCCESS_MESSAGE = "Login successful!"
const LOGIN_ERROR_MESSAGE = "Login failed: %s"
const SIGNUP_SUCCESS_MESSAGE = "Signup sucessful! You can now login."
const SIGNUP_ERROR_MESSAGE = "Signup failed: %s"


func _on_signup_pressed() -> void:
	signup_pressed.emit()


func _on_login_pressed() -> void:
	login_pressed.emit()
