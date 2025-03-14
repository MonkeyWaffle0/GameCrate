class_name Tabs
extends Control


signal tab_selected(tab_name: String)

@export var tabs_names: Array[String]
@export var tab_theme: Theme

@onready var tab_container: HBoxContainer = %TabContainer


func _ready() -> void:
	for tab_name: String in tabs_names:
		var button := Button.new()
		button.theme = tab_theme
		button.theme_type_variation = "TabButton"
		button.text = tab_name
		button.custom_minimum_size = Vector2(254, 100)
		button.pressed.connect(func(): tab_selected.emit(tab_name))
		tab_container.call_deferred("add_child", button)
