class_name Authentication
extends Control


signal signup_pressed
signal login_pressed


const LOGIN_SUCCESS_MESSAGE = "Login successful!"
const LOGIN_ERROR_MESSAGE = "Login failed: %s"
const SIGNUP_SUCCESS_MESSAGE = "Signup sucessful! You can now login."
const SIGNUP_ERROR_MESSAGE = "Signup failed: %s"

@export var main_scene: PackedScene

@onready var username: LineEdit = %Username
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
	if await UserService.is_username_available(username.text):
		AppData.user_data.username = username.text
		Firebase.Auth.signup_with_email_and_password(email.text, password.text)


func _on_login_pressed() -> void:
	Firebase.Auth.login_with_email_and_password(email.text, password.text)


func _on_login_success(auth: Dictionary) -> void:
	print("Login successful")
	auth_information.visible = true
	auth_information.theme_type_variation = "AccentLabel"
	auth_information.text = LOGIN_SUCCESS_MESSAGE
	Firebase.Auth.save_auth(auth)
	FireBaseConf.userId = Firebase.Auth.auth["localid"]
	get_tree().change_scene_to_packed(main_scene)


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
