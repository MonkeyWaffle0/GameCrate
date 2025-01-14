class_name ScrollElement
extends Control


signal selected(element: ScrollElement)

@export var button: Control


var initial_y: float
var end_y: float
var is_selected := false


func _ready() -> void:
	button.pressed.connect(_on_pressed)


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			initial_y = event.position.y
		else:
			end_y = event.position.y


func _on_pressed() -> void:
	if abs(initial_y - end_y) < 50:
		if not is_selected:
			selected.emit(self)
		else:
			set_selected(false)


func set_selected(value: bool) -> void:
	pass
