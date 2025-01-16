class_name FooterButton
extends Control


signal pressed

const SELECTED_COLOR = Color("218b65")
const UNSELECTED_COLOR = Color("b2b2b2")

@export var type: Footer.TabType
@export var selected_icon: Texture2D
@export var unselected_icon: Texture2D

@onready var icon: TextureRect = %Icon
@onready var label: Label = %Label


func _ready() -> void:
	match type:
		Footer.TabType.SEARCH:
			label.text = "Search"
		Footer.TabType.COLLECTION:
			label.text = "Collection"
		Footer.TabType.SESSIONS:
			label.text = "Sessions"
		Footer.TabType.FRIENDS:
			label.text = "Friends"
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
