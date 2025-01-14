extends Node
class_name StateMachine


signal state_changed(previous_state: BaseState, new_state: BaseState)

@export var origin: Node
@export var initial_state: BaseState

var current_state: BaseState


func _ready() -> void:
	for child in get_children():
		child.origin = origin
		child.state_change_requested.connect(change_state)
	change_state(initial_state)


func change_state(new_state: BaseState) -> void:
	if current_state:
		current_state.exit()

	var previous_state = current_state

	current_state = new_state
	current_state.enter()
	state_changed.emit(previous_state, new_state)


func _unhandled_input(event: InputEvent) -> void:
	var new_state = current_state.input(event)
	if new_state:
		change_state(new_state)


func _physics_process(delta: float) -> void:
	var new_state = current_state.physics_process(delta)
	if new_state:
		change_state(new_state)


func _process(delta: float) -> void:
	var new_state = current_state.process(delta)
	if new_state:
		change_state(new_state)
