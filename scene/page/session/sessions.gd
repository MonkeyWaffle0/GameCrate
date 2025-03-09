class_name Sessions
extends Control


signal create_session_pressed
signal session_selected(session: Session)

@onready var scroll_container: SelectionScrollContainer = %ScrollContainer


func _ready() -> void:
	await scroll_container.containers_initialized
	for session_section: SessionSection in scroll_container.get_node("%Container").get_children():
		session_section.session_selected.connect(_on_session_selected)


func _on_create_session_button_pressed() -> void:
	create_session_pressed.emit()


func _on_session_selected(session: Session) -> void:
	print("in sessions")
	session_selected.emit(session)
