class_name BaseState
extends Node


signal state_change_requested(new_state: BaseState)

@export var show_footer := true
@export var show_header := true
@export var show_back_button := false
@export var show_animated_background := false
@export var visible_components: Array[Node] = []


## Not meant to be overriden. Always called when state is entered
func init() -> void:
	AppData.footer.visible = show_footer
	AppData.header.visible = show_header
	AppData.header.show_back_button(show_back_button)
	AppData.animated_background.visible = show_animated_background
	for component in visible_components:
		component.show()
		component.enter()


## Not meant to be overriden. Always called when state is exited
func cleanup() -> void:
	AppData.footer.visible = !show_footer
	AppData.header.visible = !show_header
	AppData.animated_background.visible = !show_animated_background
	for component in visible_components:
		component.hide()
		component.exit()


## Can be overriden to add code when entering state
func enter() -> void:
	pass


## Can be overriden to add code when exiting state
func exit() -> void:
	pass


## Called for each input on the current state
func input(_event: InputEvent) -> BaseState:
	return null


## Called for each process frame on the current state
func process(_delta: float) -> BaseState:
	return null


## Called for each physics process frame on the current state
func physics_process(_delta: float) -> BaseState:
	return null
