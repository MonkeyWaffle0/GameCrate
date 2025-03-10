class_name FooterButton
extends Control


signal pressed

const SELECTED_COLOR = Color("ffffff")
const UNSELECTED_COLOR = Color("b2b2b2")

@export var type: Enums.Page
@export var selected_icon: Texture2D
@export var unselected_icon: Texture2D

@onready var icon: TextureRect = %Icon
@onready var label: Label = %Label


func _ready() -> void:
	label.text = Enums.page_to_string(type)
	icon.texture = unselected_icon


func select(value: bool) -> void:
	if value:
		label.add_theme_color_override("font_color", SELECTED_COLOR)
		icon.texture = selected_icon
	else:
		label.add_theme_color_override("font_color", UNSELECTED_COLOR)
		icon.texture = unselected_icon


func _on_button_pressed() -> void:
	pressed.emit()
