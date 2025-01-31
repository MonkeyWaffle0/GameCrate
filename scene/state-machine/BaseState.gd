class_name BaseState
extends Node


signal state_change_requested(new_state: BaseState)

@export var show_footer := true
@export var show_header := true
@export var show_animated_background := false
@export var visible_components: Array[Node] = []

var origin: Node


func enter() -> void:
	AppData.footer.visible = show_footer
	AppData.header.visible = show_header
	%AnimatedBackground.visible = show_animated_background
	for component in visible_components:
		component.show()


func exit() -> void:
	AppData.footer.visible = !show_footer
	AppData.header.visible = !show_header
	AppData.animated_background.visible = !show_animated_background
	for component in visible_components:
		component.hide()


func input(_event: InputEvent) -> BaseState:
	return null


func process(_delta: float) -> BaseState:
	return null


func physics_process(_delta: float) -> BaseState:
	return null
