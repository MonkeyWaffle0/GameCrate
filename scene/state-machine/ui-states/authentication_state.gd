class_name UiAuthenticationState
extends BaseState


@export var authentication: Authentication
@export var signup_state: UiSignupState
@export var login_state: UiLoginState
@export var search_state: UiSearchState
@export var first_login_state: UiFirstLoginState
@export var footer: Footer
@export var header: Header


func enter() -> void:
	Firebase.Auth.login_succeeded.connect(_on_login_success)
	Firebase.Auth.check_auth_file()
	authentication.show()
	authentication.signup_pressed.connect(_on_signup)
	authentication.login_pressed.connect(_on_login)
	footer.hide()
	header.hide()


func exit() -> void:
	authentication.hide()
	Firebase.Auth.login_succeeded.disconnect(_on_login_success)
	authentication.signup_pressed.disconnect(_on_signup)
	authentication.login_pressed.disconnect(_on_login)
	footer.show()
	header.show()


func _on_signup() -> void:
	state_change_requested.emit(signup_state)


func _on_login() -> void:
	state_change_requested.emit(login_state)
	

func _on_login_success(auth: Dictionary) -> void:
	Firebase.Auth.save_auth(auth)
	FireBaseConf.userId = Firebase.Auth.auth["localid"]
	FireBaseConf.Init(auth)
	var is_first_login := await UserService.is_first_login()
	if is_first_login:
		state_change_requested.emit(first_login_state)
	else:
		state_change_requested.emit(search_state)
