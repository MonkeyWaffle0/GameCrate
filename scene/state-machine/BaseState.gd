class_name BaseState
extends Node


signal stage_change_requested(new_state: BaseState)

var origin: Node


func enter() -> void:
	pass

func exit() -> void:
	pass

func input(_event: InputEvent) -> BaseState:
	return null

func process(_delta: float) -> BaseState:
	return null

func physics_process(_delta: float) -> BaseState:
	return null
