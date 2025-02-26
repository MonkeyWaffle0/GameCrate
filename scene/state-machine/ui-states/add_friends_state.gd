class_name UiAddFriendsState
extends BaseState


@export var friends_state: UiFriendsState


func enter() -> void:
	super.enter()
	AppData.header.back_pressed.connect(_on_back_pressed)


func exit() -> void:
	super.exit()
	AppData.header.back_pressed.disconnect(_on_back_pressed)


func _on_back_pressed() -> void:
	state_change_requested.emit(friends_state)
