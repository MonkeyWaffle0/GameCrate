class_name IconButton
extends Control


signal pressed

@onready var button: Button = %Button
@onready var icon: TextureRect = %Icon


func enable(value: bool) -> void:
	button.disabled = not value


func set_icon(texture: Texture) -> void:
	icon.texture = texture


func _on_button_pressed() -> void:
	pressed.emit()
