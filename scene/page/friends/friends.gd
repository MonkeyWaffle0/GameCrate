class_name Friends
extends Control


signal add_friends_pressed

@export var action_friend_info_scene: PackedScene

@onready var scroll_container: SelectionScrollContainer = %ScrollContainer
@onready var empty_state: VBoxContainer = %EmptyState


func _ready() -> void:
	AppData.user_data.friendships_changed.connect(_on_friendships_changed)


func _on_add_friend_button_pressed() -> void:
	add_friends_pressed.emit()


func _on_friendships_changed() -> void:
	var is_empty := AppData.user_data.friendships.is_empty()
	empty_state.visible = is_empty
	scroll_container.visible = !is_empty
