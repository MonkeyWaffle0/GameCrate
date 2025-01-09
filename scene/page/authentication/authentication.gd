extends Control


const LOGIN_SUCCESS_MESSAGE = "Login successful!"
const LOGIN_ERROR_MESSAGE = "Login failed: %s"
const SIGNUP_SUCCESS_MESSAGE = "Signup sucessful! You can now login."
const SIGNUP_ERROR_MESSAGE = "Signup failed: %s"

@export var search_scene: PackedScene

@onready var email: LineEdit = %Email
@onready var password: LineEdit = %Password
@onready var auth_information: Label = %AuthInformation


func _ready() -> void:
	Firebase.Auth.login_succeeded.connect(_on_login_success)
	Firebase.Auth.login_failed.connect(_on_login_failed)
	Firebase.Auth.signup_succeeded.connect(_on_signup_succeeded)
	Firebase.Auth.signup_failed.connect(_on_signup_failed)
	Firebase.Auth.check_auth_file()


func _on_signup_pressed() -> void:
	Firebase.Auth.signup_with_email_and_password(email.text, password.text)


func _on_login_pressed() -> void:
	Firebase.Auth.login_with_email_and_password(email.text, password.text)


func _on_login_success(auth: Dictionary) -> void:
	print("Login sucessful")
	auth_information.visible = true
	auth_information.theme_type_variation = "AccentLabel"
	auth_information.text = LOGIN_SUCCESS_MESSAGE
	Firebase.Auth.save_auth(auth)
	get_tree().change_scene_to_packed(search_scene)


func _on_login_failed(error_code: int, message: String) -> void:
	printerr("Login failed with error code %s: %s" % [error_code, message])
	auth_information.visible = true
	auth_information.theme_type_variation = "ErrorLabel"
	auth_information.text = LOGIN_ERROR_MESSAGE % [message]


func _on_signup_succeeded(auth: Dictionary) -> void:
	print("Signup sucessful")
	auth_information.visible = true
	auth_information.theme_type_variation = "AccentLabel"
	auth_information.text = SIGNUP_SUCCESS_MESSAGE
	Firebase.Auth.save_auth(auth)


func _on_signup_failed(error_code: int, message: String) -> void:
	printerr("Signup failed with error code %s: %s" % [error_code, message])
	auth_information.visible = true
	auth_information.theme_type_variation = "ErrorLabel"
	auth_information.text = SIGNUP_ERROR_MESSAGE % [message]
