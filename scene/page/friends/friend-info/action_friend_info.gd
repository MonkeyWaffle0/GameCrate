class_name ActionFriendInfo
extends Control


enum Type { RECEIVED, SENT, FRIEND }

@onready var friend_info: FriendInfo = %FriendInfo
@onready var spinner: MarginContainer = %Spinner
@onready var delete_button: IconButton = %DeleteButton
@onready var accept_reject_container: HBoxContainer = %AcceptRejectContainer

var type: Type
var user_search_data: UserSearchData:
	set(value):
		user_search_data = value
		if friend_info:
			friend_info.user_search_data = user_search_data


func _ready() -> void:
	if user_search_data:
		friend_info.user_search_data = user_search_data
	accept_reject_container.visible = type == Type.RECEIVED
	delete_button.visible = type == Type.SENT or type == Type.FRIEND


func _on_delete_button_pressed() -> void:
	spinner.show()
	delete_button.hide()
	var success := false
	match type:
		Type.SENT:
			success = await FriendService.delete_sent(user_search_data)
		Type.FRIEND:
			success = await FriendService.delete_friend(user_search_data)

	if not success:
		spinner.hide()
		delete_button.show()


func _on_accept_button_pressed() -> void:
	spinner.show()
	accept_reject_container.hide()


func _on_reject_button_pressed() -> void:
	spinner.show()
	accept_reject_container.hide()
	var success := await FriendService.delete_received(user_search_data)
	if not success:
		spinner.hide()
		accept_reject_container.show()
