class_name Login
extends Control


const LOGIN_ERROR_MESSAGE := "Login failed: %s"

@onready var login_button: Control = %LoginButton
@onready var email: LineEdit = %Email
@onready var password: LineEdit = %Password
@onready var auth_information: Label = %AuthInformation


func _ready() -> void:
	Firebase.Auth.login_failed.connect(_on_login_failed)


func _on_login_button_pressed() -> void:
	login_button.disabled = true
	Firebase.Auth.login_with_email_and_password(email.text, password.text)


func _on_login_failed(error_code: int, message: String) -> void:
	login_button.disabled = false
	printerr("Login failed with error code %s: %s" % [error_code, message])
	auth_information.theme_type_variation = "ErrorLabel"
	auth_information.text = LOGIN_ERROR_MESSAGE % [message]
	
