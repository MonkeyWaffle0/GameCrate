class_name UiFirstLoginState
extends BaseState


@export var first_login: FirstLogin
@export var search_state: UiSearchState


func enter() -> void:
	super.enter()
	first_login.username_saved.connect(_on_username_saved)


func exit() -> void:
	super.exit()
	first_login.username_saved.disconnect(_on_username_saved)


func _on_username_saved() -> void:
	state_change_requested.emit(search_state)
