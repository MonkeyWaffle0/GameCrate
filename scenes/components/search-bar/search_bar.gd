class_name SearchBar
extends Panel


signal search_requested(value: String)
signal text_changed(value: String)

@export var placeholder_value: String

@onready var search_value: LineEdit = %SearchValue


func _ready() -> void:
	search_value.placeholder_text = placeholder_value


func get_value() -> String:
	return search_value.text


func _on_search_button_pressed() -> void:
	search_requested.emit(get_value())


func _on_search_value_text_submitted(_new_text: String) -> void:
	search_requested.emit(get_value())


func _on_search_value_text_changed(new_text: String) -> void:
	text_changed.emit(new_text)
