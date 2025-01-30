class_name UiFirstLoginState
extends BaseState


@export var first_login: FirstLogin
@export var search_state: UiSearchState
@export var footer: Footer
@export var header: Header


func enter() -> void:
	first_login.show()
	footer.hide()
	header.hide()
	first_login.username_saved.connect(_on_username_saved)


func exit() -> void:
	first_login.hide()
	footer.show()
	header.show()
	first_login.username_saved.disconnect(_on_username_saved)


func _on_username_saved() -> void:
	state_change_requested.emit(search_state)
