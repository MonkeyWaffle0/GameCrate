class_name UiAuthenticationState
extends BaseState


@export var authentication: Authentication
@export var signup_state: UiSignupState
@export var login_state: UiLoginState
@export var footer: Footer
@export var header: Header


func enter() -> void:
	authentication.signup_pressed.connect(_on_signup)
	authentication.login_pressed.connect(_on_login)
	footer.hide()
	header.hide()


func exit() -> void:
	authentication.signup_pressed.disconnect(_on_signup)
	authentication.login_pressed.disconnect(_on_login)


func _on_signup() -> void:
	state_change_requested.emit(signup_state)


func _on_login() -> void:
	state_change_requested.emit(login_state)
