class_name IconButton
extends Control


signal pressed

@onready var button: Button = %Button


func enable(value: bool) -> void:
	button.disabled = not value


func _on_button_pressed() -> void:
	pressed.emit()
