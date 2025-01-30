class_name Footer
extends Control


signal footer_changed(type: Enums.Page)

@onready var container: HBoxContainer = %Container

var current_tab := Enums.Page.SEARCH


func _ready() -> void:
	await get_tree().create_timer(0.25).timeout
	footer_changed.emit(Enums.Page.SEARCH)


func do_selection(type: Enums.Page) -> void:
	current_tab = type
	for child in container.get_children():
		child.select(child.type == type)


func _on_search_button_pressed() -> void:
	if not current_tab == Enums.Page.SEARCH:
		footer_changed.emit(Enums.Page.SEARCH)


func _on_collection_button_pressed() -> void:
	if not current_tab == Enums.Page.COLLECTION:
		footer_changed.emit(Enums.Page.COLLECTION)


func _on_friends_button_pressed() -> void:
	if not current_tab == Enums.Page.FRIENDS:
		footer_changed.emit(Enums.Page.FRIENDS)


func _on_sessions_button_pressed() -> void:
	if not current_tab == Enums.Page.SESSIONS:
		footer_changed.emit(Enums.Page.SESSIONS)
