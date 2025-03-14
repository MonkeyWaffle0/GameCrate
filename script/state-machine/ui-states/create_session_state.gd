class_name UiCreateSessionState
extends BaseState


@export var create_session: CreateSession
@export var sessions_state: UiSessionsState
@export var session_details_state: UiSesstionDetailsState


func enter() -> void:
	create_session.fill()
	create_session.session_created.connect(_on_session_created)
	AppData.header.back_pressed.connect(_on_back_pressed)


func exit() -> void:
	AppData.header.back_pressed.disconnect(_on_back_pressed)


func _on_back_pressed() -> void:
	state_change_requested.emit(sessions_state)


func _on_session_created(session: Session) -> void:
	AppData.current_session = session
	state_change_requested.emit(session_details_state)
