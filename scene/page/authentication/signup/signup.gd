class_name Signup
extends Control


const SIGNUP_ERROR_MESSAGE := "Signup failed: %s"
const USERNAME_TOO_SHORT_MESSAGE := "Username must be at least 3 characters."
const USERNAME_ALREADY_USED_MESSAGE := "Username is already used."

@onready var signup_button: Button = %SignupButton
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


func _on_signup_button_pressed() -> void:
	if len(username.text) < 3:
		show_message("ErrorLabel", USERNAME_TOO_SHORT_MESSAGE)
		return
	if await UserService.is_username_available(username.text):
		username.editable = false
		email.editable = false
		password.editable = false
		AppData.user_data.username = username.text
		Firebase.Auth.signup_with_email_and_password(email.text, password.text)
	else:
		show_message("ErrorLabel", USERNAME_ALREADY_USED_MESSAGE)


func show_message(type: String, message: String) -> void:
	auth_information.show()
	auth_information.theme_type_variation = type
	auth_information.text = message


func _on_login_success(auth: Dictionary) -> void:
	print("Login successful")
	Firebase.Auth.save_auth(auth)
	FireBaseConf.userId = Firebase.Auth.auth["localid"]


func _on_login_failed(error_code: int, message: String) -> void:
	printerr("Login failed with error code %s: %s" % [error_code, message])


func _on_signup_succeeded(auth: Dictionary) -> void:
	print("Signup successful")
	Firebase.Auth.save_auth(auth)


func _on_signup_failed(error_code: int, message: String) -> void:
	username.editable = true
	email.editable = true
	password.editable = true
	printerr("Signup failed with error code %s: %s" % [error_code, message])
	show_message("ErrorLabel", SIGNUP_ERROR_MESSAGE % [message])
