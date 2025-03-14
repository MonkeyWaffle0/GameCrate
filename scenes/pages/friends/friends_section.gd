class_name FriendsSection
extends Control


enum Type { SENT, RECEIVED, FRIENDS }

@export var type: Type
@export var action_friend_info_scene: PackedScene

@onready var container: VBoxContainer = %Container
@onready var friends_empty_state: VBoxContainer = %FriendsEmptyState
@onready var received_empty_state: VBoxContainer = %ReceivedEmptyState
@onready var sent_empty_state: VBoxContainer = %SentEmptyState


func add_element(friendship: Friendship) -> void:
	var action_friend_info := action_friend_info_scene.instantiate() as ActionFriendInfo
	action_friend_info.friendship = friendship
	container.call_deferred("add_child", action_friend_info)


func enable(is_enabled: bool) -> void:
	visible = is_enabled
	if is_enabled:
		if not AppData.user_data.friendships_changed.is_connected(_on_friendships_changed):
			AppData.user_data.friendships_changed.connect(_on_friendships_changed)
		_on_friendships_changed()
	else:
		if AppData.user_data.friendships_changed.is_connected(_on_friendships_changed):
			AppData.user_data.friendships_changed.disconnect(_on_friendships_changed)


func clear() -> void:
	for child in container.get_children():
		child.queue_free()


func get_element_count() -> int:
	return container.get_child_count()


func _on_friendships_changed() -> void:
	var friendships := AppData.user_data.friendships
	var user_id := AppData.get_user_id()

	if type == Type.SENT:
		var sent_friendships := friendships.filter(func(frd: Friendship) -> bool: return is_sent_friendship(user_id, frd))
		if sent_friendships.is_empty():
			sent_empty_state.show()
			return
		sent_empty_state.hide()
		for friendship: Friendship in sent_friendships:
			if not already_exists(friendship):
				add_element(friendship)
		for child: ActionFriendInfo in container.get_children():
			if is_not_in(child.friendship, sent_friendships):
				child.queue_free()

	elif type == Type.RECEIVED:
		var received_friendships := friendships.filter(func(frd: Friendship) -> bool: return is_received_friendship(user_id, frd))
		if received_friendships.is_empty():
			received_empty_state.show()
			return
		received_empty_state.hide()
		for friendship: Friendship in received_friendships:
			if not already_exists(friendship):
				add_element(friendship)
		for child: ActionFriendInfo in container.get_children():
			if is_not_in(child.friendship, received_friendships):
				child.queue_free()

	elif type == Type.FRIENDS:
		var friends := friendships.filter(func(frd: Friendship) -> bool: return is_friend(frd))
		if friends.is_empty():
			friends_empty_state.show()
			return
		friends_empty_state.hide()
		for friendship: Friendship in friends:
			if not already_exists(friendship):
				add_element(friendship)
		for child: ActionFriendInfo in container.get_children():
			if is_not_in(child.friendship, friends):
				child.queue_free()


func already_exists(friendship: Friendship) -> bool:
	for child: ActionFriendInfo in container.get_children():
		if child.friendship.id == friendship.id and friendship.status == child.friendship.status:
			return true
	return false


func is_not_in(friendship: Friendship, friendships: Array[Friendship]) -> bool:
	return friendship.id not in friendships.map(func(fr): return fr.id)


func is_sent_friendship(user_id: String, friendship: Friendship) -> bool:
	return friendship.status == Friendship.Status.PENDING and friendship.sender == user_id


func is_received_friendship(user_id: String, friendship: Friendship) -> bool:
	return friendship.status == Friendship.Status.PENDING and friendship.receiver == user_id


func is_friend(friendship: Friendship) -> bool:
	return friendship.status == Friendship.Status.ACCEPTED
