class_name UiSignupState
extends BaseState


@export var header: Header
@export var footer: Footer
@export var signup: Signup
@export var authentication_state: UiAuthenticationState
@export var first_login_state: UiFirstLoginState


func enter() -> void:
	header.hide()
	footer.hide()
	signup.show()
	Firebase.Auth.login_succeeded.connect(_on_login_succeeded)
	Firebase.Auth.signup_succeeded.connect(_on_signup_succeeded)


func exit() -> void:
	signup.hide()
	Firebase.Auth.login_succeeded.disconnect(_on_login_succeeded)
	Firebase.Auth.signup_succeeded.disconnect(_on_signup_succeeded)
	header.show()
	footer.show()


func _on_login_succeeded(auth: Dictionary) -> void:
	Firebase.Auth.save_auth(auth)
	FireBaseConf.userId = Firebase.Auth.auth["localid"]
	FireBaseConf.Init(auth)
	state_change_requested.emit(first_login_state)


func _on_signup_succeeded(auth: Dictionary) -> void:
	signup.login()
