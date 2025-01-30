class_name UiSignupState
extends BaseState


@export var header: Header
@export var footer: Footer
@export var authentication_state: UiAuthenticationState
@export var search_state: UiSearchState


func enter() -> void:
	header.hide()
	footer.hide()
	Firebase.Auth.login_succeded.connect(_on_login_succeeded)


func exit() -> void:
	Firebase.Auth.login_succeded.disconnect(_on_login_succeeded)
	header.show()
	footer.show()


func _on_login_succeeded(auth: Dictionary) -> void:
	Firebase.Auth.save_auth(auth)
	FireBaseConf.userId = Firebase.Auth.auth["localid"]
	state_change_requested.emit(search_state)
