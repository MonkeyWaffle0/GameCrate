class_name Header
extends Control


@onready var label: Label = %Label


func _ready() -> void:
	Signals.page_changed.connect(_on_page_changed)
	

func _on_page_changed(type: Enums.Page) -> void:
	label.text = Enums.page_to_string(type)
