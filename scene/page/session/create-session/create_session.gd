class_name CreateSession
extends Control


signal session_created(session: Session)

@export var create_session_friend_info_scene: PackedScene

@onready var participants_container: VBoxContainer = %ParticipantsContainer
@onready var friends_container: VBoxContainer = %FriendsContainer
@onready var date_picker_panel: PanelContainer = %DatePickerPanel


func fill() -> void:
	clear_all()
	var friends := AppData.user_data.get_friends()
	for friend: Friendship in friends:
		var create_session_friend_info := create_session_friend_info_scene.instantiate() as CreateSessionFriendInfo
		create_session_friend_info.friendship = friend
		create_session_friend_info.added.connect(_on_added)
		create_session_friend_info.removed.connect(_on_removed)
		friends_container.call_deferred("add_child", create_session_friend_info)


func clear_all() -> void:
	for child in participants_container.get_children():
		child.queue_free()
	for child in friends_container.get_children():
		child.queue_free()


func change_visibility(is_visible: bool) -> void:
	for child in participants_container.get_children():
		child.visible = is_visible
	for child in friends_container.get_children():
		child.visible = is_visible


func sort_elements(container: VBoxContainer) -> void:
	var children := container.get_children()
	children.sort_custom(_compare_usernames)
	for i in range(children.size()):
		container.move_child(children[i], i)


func _compare_usernames(a: CreateSessionFriendInfo, b: CreateSessionFriendInfo) -> bool:
	if a.friendship.other_username < b.friendship.other_username:
		return true
	return false


func _on_search_bar_text_changed(value: String) -> void:
	if value == "":
		change_visibility(true)
		return
	var friends := AppData.user_data.get_friends()
	var filtered_friends := friends \
		.filter(func(friendship: Friendship) -> bool: return friendship.other_username.contains(value)) \
		.map(func(friendship: Friendship) -> String: return friendship.other_username)
	for participant in participants_container.get_children():
		participant.visible = participant.friendship.other_username in filtered_friends
	for friend in friends_container.get_children():
		friend.visible = friend.friendship.other_username in filtered_friends
	sort_elements(participants_container)
	sort_elements(friends_container)


func _on_added(create_session_friend_info: CreateSessionFriendInfo) -> void:
	friends_container.remove_child(create_session_friend_info)
	participants_container.add_child(create_session_friend_info)
	create_session_friend_info.is_participant = true
	sort_elements(participants_container)
	sort_elements(friends_container)


func _on_removed(create_session_friend_info: CreateSessionFriendInfo) -> void:
	participants_container.remove_child(create_session_friend_info)
	friends_container.add_child(create_session_friend_info)
	create_session_friend_info.is_participant = false
	sort_elements(participants_container)
	sort_elements(friends_container)


func _on_create_session_button_pressed() -> void:
	var p := participants_container \
		.get_children() \
		.map(func(child: CreateSessionFriendInfo) -> String: return child.friendship.get_other_user_id())
	p.append(AppData.get_user_id())
	# Necessary to have an Array[String] and not an Array...
	var participants: Array[String] = []
	for prt in p:
		participants.append(prt)
	var session := Session.new(UUID.random_uuid(), AppData.get_user_id(), participants, date_picker_panel.get_date_string())
	var success := await SessionService.create_session(session)
	if success:
		session_created.emit(session)
