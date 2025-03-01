class_name UiCreateSessionState
extends BaseState


@export var create_session: CreateSession
@export var sessions_state: UiSessionsState


func enter() -> void:
	super.enter()
	create_session.fill()
	create_session.session_created.connect(_on_session_created)
	AppData.header.back_pressed.connect(_on_back_pressed)


func exit() -> void:
	super.exit()
	AppData.header.back_pressed.disconnect(_on_back_pressed)


func _on_back_pressed() -> void:
	state_change_requested.emit(sessions_state)


func _on_session_created() -> void:
	print("session created")
