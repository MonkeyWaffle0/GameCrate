extends Control


signal pressed

@export var text: String

@onready var button: Button = %Button

var disabled := false:
	set(value):
		disabled = value
		if button:
			button.disabled = disabled


func _ready() -> void:
	button.text = text


func _on_button_pressed() -> void:
	pressed.emit()
