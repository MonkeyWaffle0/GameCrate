class_name UiLoginState
extends BaseState


@export var authentication_state: UiAuthenticationState
@export var search_state: UiSearchState
@export var first_login_state: UiFirstLoginState


func enter() -> void:
	super.enter()
	Firebase.Auth.login_succeeded.connect(_on_login_succeeded)


func exit() -> void:
	super.exit()
	Firebase.Auth.login_succeeded.disconnect(_on_login_succeeded)


func _on_login_succeeded(auth: Dictionary) -> void:
	Firebase.Auth.save_auth(auth)
	FireBaseConf.userId = Firebase.Auth.auth["localid"]
	var is_first_login := await UserService.is_first_login()
	if is_first_login:
		state_change_requested.emit(first_login_state)
	else:
		state_change_requested.emit(search_state)
