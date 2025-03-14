class_name Tabs
extends Control


signal tab_selected(tab_name: String)

const TAB_BUTTON_THEME_VARIATION := "TabButton"
const SELECTED_TAB_BUTTON_THEME_VARIATION := "SelectedTabButton"

@export var tabs_names: Array[String]
@export var tab_theme: Theme

@onready var tab_container: HBoxContainer = %TabContainer


func _ready() -> void:
	for tab_name: String in tabs_names:
		var button := Button.new()
		button.theme = tab_theme
		button.theme_type_variation = TAB_BUTTON_THEME_VARIATION
		button.text = tab_name
		button.custom_minimum_size = Vector2(254, 100)
		button.pressed.connect(func(): _on_tab_button_pressed(button, tab_name))
		tab_container.call_deferred("add_child", button)


## Can be used to manually select a tab from outside of the tabs component
func select_tab(tab_name: String) -> void:
	for tab_button: Button in tab_container.get_children():
		if tab_button.text == tab_name:
			_on_tab_button_pressed(tab_button, tab_name)
			return


func _on_tab_button_pressed(button: Button, tab_name: String) -> void:
	for tab_button in tab_container.get_children():
		if tab_button == button:
			tab_button.theme_type_variation = SELECTED_TAB_BUTTON_THEME_VARIATION
		else:
			tab_button.theme_type_variation = TAB_BUTTON_THEME_VARIATION
	tab_selected.emit(tab_name)
