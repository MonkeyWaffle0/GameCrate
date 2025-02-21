class_name Header
extends Control


@onready var label: Label = %Label
@onready var back_button: IconButton = %BackButton


func _ready() -> void:
	AppData.header = self
	Signals.page_changed.connect(_on_page_changed)
	

func _on_page_changed(type: Enums.Page) -> void:
	label.text = Enums.page_to_string(type)


func show_back_button(is_visible: bool) -> void:
	back_button.visible = is_visible
