class_name FirstLogin
extends Control


signal username_saved

const USERNAME_TOO_SHORT_MESSAGE := "Username must be at least 3 characters."
const USERNAME_ALREADY_USED_MESSAGE := "Username is already used."

@onready var username: LineEdit = %Username
@onready var continue_button: Button = %ContinueButton
@onready var auth_information: Label = %AuthInformation


func _on_continue_button_pressed() -> void:
	if len(username.text) < 3:
		auth_information.theme_type_variation = "ErrorLabel"
		auth_information.text = USERNAME_TOO_SHORT_MESSAGE
		return
	username.editable = false
	continue_button.disabled = true
	if await UserService.is_username_available(username.text):
		await UserService.save_username(username.text)
		AppData.user_data.username = username.text
		username_saved.emit()
	else:
		username.editable = true
		continue_button.disabled = false
		auth_information.theme_type_variation = "ErrorLabel"
		auth_information.text = USERNAME_ALREADY_USED_MESSAGE
