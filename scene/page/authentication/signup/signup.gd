class_name Signup
extends Control


const SIGNUP_ERROR_MESSAGE := "Signup failed: %s"
const PASSWORDS_DONT_MATCH_MESSAGE := "Passwords don't match."

@onready var signup_button: Button = %SignupButton
@onready var email: LineEdit = %Email
@onready var password: LineEdit = %Password
@onready var password_confirm: LineEdit = %PasswordConfirm
@onready var auth_information: Label = %AuthInformation


func _ready() -> void:
	Firebase.Auth.login_failed.connect(_on_login_failed)
	Firebase.Auth.signup_failed.connect(_on_signup_failed)


func _on_signup_button_pressed() -> void:
	if password.text != password_confirm.text:
		show_message("ErrorLabel", PASSWORDS_DONT_MATCH_MESSAGE)
		return
	signup_button.disabled = true
	email.editable = false
	password.editable = false
	password_confirm.editable = false
	Firebase.Auth.signup_with_email_and_password(email.text, password.text)


func show_message(type: String, message: String) -> void:
	auth_information.theme_type_variation = type
	auth_information.text = message


func _on_login_failed(error_code: int, message: String) -> void:
	printerr("Login failed with error code %s: %s" % [error_code, message])


func _on_signup_failed(error_code: int, message: String) -> void:
	signup_button.disabled = false
	email.editable = true
	password.editable = true
	password_confirm.editable = true
	printerr("Signup failed with error code %s: %s" % [error_code, message])
	show_message("ErrorLabel", SIGNUP_ERROR_MESSAGE % [message])
