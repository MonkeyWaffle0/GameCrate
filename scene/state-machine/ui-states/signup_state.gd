class_name UiSignupState
extends BaseState


@export var signup: Signup
@export var authentication_state: UiAuthenticationState
@export var first_login_state: UiFirstLoginState


func enter() -> void:
	super.enter()
	Firebase.Auth.login_succeeded.connect(_on_login_succeeded)
	Firebase.Auth.signup_succeeded.connect(_on_signup_succeeded)


func exit() -> void:
	super.exit()
	Firebase.Auth.login_succeeded.disconnect(_on_login_succeeded)
	Firebase.Auth.signup_succeeded.disconnect(_on_signup_succeeded)


func _on_login_succeeded(auth: Dictionary) -> void:
	Firebase.Auth.save_auth(auth)
	FireBaseConf.userId = Firebase.Auth.auth["localid"]
	state_change_requested.emit(first_login_state)


func _on_signup_succeeded(auth: Dictionary) -> void:
	Firebase.Auth.save_auth(auth)
	Firebase.Auth.check_auth_file()
