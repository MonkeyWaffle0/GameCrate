class_name Footer
extends Control


signal tab_changed(tab_type: TabType)


enum TabType { SEARCH, COLLECTION, SESSIONS, FRIENDS }


func _on_search_button_pressed() -> void:
	tab_changed.emit(TabType.SEARCH)


func _on_collection_button_pressed() -> void:
	tab_changed.emit(TabType.COLLECTION)


func _on_session_button_pressed() -> void:
	tab_changed.emit(TabType.SESSIONS)


func _on_friends_button_pressed() -> void:
	tab_changed.emit(TabType.FRIENDS)
