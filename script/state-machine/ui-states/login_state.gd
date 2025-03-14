class_name UiLoginState
extends BaseState


@export var authentication_state: UiAuthenticationState
@export var search_state: UiSearchState
@export var first_login_state: UiFirstLoginState


func enter() -> void:
	Firebase.Auth.login_succeeded.connect(_on_first_login_succeeded)


func exit() -> void:
	if Firebase.Auth.login_succeeded.is_connected(_on_first_login_succeeded):
		Firebase.Auth.login_succeeded.disconnect(_on_first_login_succeeded)
	if Firebase.Auth.login_succeeded.is_connected(_on_real_login_succeeded):
		Firebase.Auth.login_succeeded.disconnect(_on_real_login_succeeded)


## Auth data with the first login with username / password does not contain the access token. So we use
## Firebase.Auth.check_auth_file() to get it.
func _on_first_login_succeeded(auth: Dictionary) -> void:
	Firebase.Auth.login_succeeded.disconnect(_on_first_login_succeeded)
	Firebase.Auth.login_succeeded.connect(_on_real_login_succeeded)
	Firebase.Auth.save_auth(auth)
	Firebase.Auth.check_auth_file()


func _on_real_login_succeeded(auth: Dictionary) -> void:
	FireBaseConf.userId = AppData.get_user_id()
	FireBaseConf.Init(auth)
	var is_first_login := await UserService.is_first_login()
	if is_first_login:
		state_change_requested.emit(first_login_state)
	else:
		state_change_requested.emit(search_state)
