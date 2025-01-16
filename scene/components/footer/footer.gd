class_name Footer
extends Control


signal footer_changed(type: TabType)

enum TabType { SEARCH, COLLECTION, SESSIONS, FRIENDS }

@onready var container: HBoxContainer = %Container

var current_tab := TabType.SEARCH



func _ready() -> void:
	await get_tree().create_timer(0.25).timeout
	footer_changed.emit(TabType.SEARCH)


func do_selection(type: TabType) -> void:
	current_tab = type
	for child in container.get_children():
		child.select(child.type == type)


func _on_search_button_pressed() -> void:
	if not current_tab == TabType.SEARCH:
		footer_changed.emit(TabType.SEARCH)


func _on_collection_button_pressed() -> void:
	if not current_tab == TabType.COLLECTION:
		footer_changed.emit(TabType.COLLECTION)


func _on_friends_button_pressed() -> void:
	if not current_tab == TabType.FRIENDS:
		footer_changed.emit(TabType.FRIENDS)


func _on_sessions_button_pressed() -> void:
	if not current_tab == TabType.SESSIONS:
		footer_changed.emit(TabType.SESSIONS)
