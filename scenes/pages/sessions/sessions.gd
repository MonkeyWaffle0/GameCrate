class_name Sessions
extends StateMachineComponent


signal create_session_pressed
signal session_selected(session: Session)

@onready var tabs: Tabs = %Tabs
@onready var upcoming_session_section: SessionSection = %UpcomingSessionSection
@onready var previous_session_section: SessionSection = %PreviousSessionSection


func _ready() -> void:
	tabs.tab_selected.connect(_on_tab_selected)


func enter() -> void:
	change_tab("Upcoming")


func change_tab(tab_name: String) -> void:
	upcoming_session_section.enable(tab_name == "Upcoming")
	previous_session_section.enable(tab_name == "Previous")


func _on_tab_selected(tab_name: String) -> void:
	change_tab(tab_name)


func _on_create_session_button_pressed() -> void:
	create_session_pressed.emit()


func _on_session_selected(session: Session) -> void:
	session_selected.emit(session)
