class_name Sessions
extends StateMachineComponent


signal create_session_pressed
signal session_selected(session: Session)

@onready var scroll_container: SelectionScrollContainer = %ScrollContainer
@onready var empty_state: VBoxContainer = %EmptyState


func _ready() -> void:
	AppData.user_data.sessions_changed.connect(_on_sessions_changed)
	await scroll_container.containers_initialized
	for session_section: SessionSection in scroll_container.get_node("%Container").get_children():
		session_section.session_selected.connect(_on_session_selected)


func _on_create_session_button_pressed() -> void:
	create_session_pressed.emit()


func _on_session_selected(session: Session) -> void:
	session_selected.emit(session)


func _on_sessions_changed() -> void:
	var is_empty := AppData.user_data.sessions.is_empty()
	empty_state.visible = is_empty
	scroll_container.visible = !is_empty
