class_name ActionFriendInfo
extends ScrollElement


@onready var friend_info: FriendInfo = %FriendInfo
@onready var spinner: MarginContainer = %Spinner
@onready var delete_button: IconButton = %DeleteButton
@onready var accept_reject_container: HBoxContainer = %AcceptRejectContainer

var user_search_data: UserSearchData:
	set(value):
		user_search_data = value
		if friend_info:
			friend_info.user_search_data = user_search_data
var friendship: Friendship


func _ready() -> void:
	if user_search_data:
		friend_info.user_search_data = user_search_data
	accept_reject_container.visible = is_received_friendship()
	delete_button.visible = is_friend() or is_sent_friendship()


func is_received_friendship() -> bool:
	return friendship.status == Friendship.Status.PENDING and friendship.sender == user_search_data.id


func is_friend() -> bool:
	return friendship.status == Friendship.Status.ACCEPTED


func is_sent_friendship() -> bool:
	return friendship.status == Friendship.Status.PENDING and friendship.receiver == user_search_data.id


func _on_delete_button_pressed() -> void:
	spinner.show()
	delete_button.hide()
	var success := await FriendService.update_friendship_status(friendship.id, Friendship.Status.DELETED)
	if not success:
		spinner.hide()
		delete_button.show()


func _on_accept_button_pressed() -> void:
	spinner.show()
	accept_reject_container.hide()
	var success := await FriendService.update_friendship_status(friendship.id, Friendship.Status.ACCEPTED)
	if not success:
		spinner.hide()
		accept_reject_container.show()


func _on_reject_button_pressed() -> void:
	spinner.show()
	accept_reject_container.hide()
	var success := await FriendService.update_friendship_status(friendship.id, Friendship.Status.REJECTED)
	if not success:
		spinner.hide()
		accept_reject_container.show()
