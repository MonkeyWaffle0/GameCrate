class_name Friends
extends StateMachineComponent


signal add_friends_pressed

@export var action_friend_info_scene: PackedScene

@onready var tabs: Tabs = %Tabs
@onready var friends_section: FriendsSection = %FriendsSection
@onready var sent_section: FriendsSection = %SentSection
@onready var received_section: FriendsSection = %ReceivedSection


func _ready() -> void:
	tabs.tab_selected.connect(_on_tab_selected)


func enter() -> void:
	change_tab("Friends")


func change_tab(tab_name: String) -> void:
	friends_section.enable(tab_name == "Friends")
	sent_section.enable(tab_name == "Sent")
	received_section.enable(tab_name == "Received")


func _on_add_friend_button_pressed() -> void:
	add_friends_pressed.emit()


func _on_tab_selected(tab_name: String) -> void:
	change_tab(tab_name)
