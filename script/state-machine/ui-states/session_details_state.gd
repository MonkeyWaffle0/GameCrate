class_name UiSesstionDetailsState
extends BaseState


@export var sessions_state: UiSessionsState
@export var session_details: SessionDetails


func enter() -> void:
	SessionService.listen_to_session(AppData.current_session.id)
	AppData.header.back_pressed.connect(_on_back_pressed)
	session_details.fill()


func exit() -> void:
	AppData.header.back_pressed.disconnect(_on_back_pressed)


func _on_back_pressed() -> void:
	state_change_requested.emit(sessions_state)
