class_name SessionSection
extends Control


signal session_selected(session: Session)

enum Type { UPCOMING, PASSED }

@export var type: Type
@export var session_info_scene: PackedScene

@onready var container: VBoxContainer = %Container
@onready var empty_state: VBoxContainer = %EmptyState


func _ready() -> void:
	AppData.user_data.sessions_changed.connect(_on_sessions_changed)


func enable(is_enabled: bool) -> void:
	visible = is_enabled
	if is_enabled:
		if not AppData.user_data.sessions_changed.is_connected(_on_sessions_changed):
			AppData.user_data.sessions_changed.connect(_on_sessions_changed)
		_on_sessions_changed()
	else:
		if AppData.user_data.sessions_changed.is_connected(_on_sessions_changed):
			AppData.user_data.sessions_changed.disconnect(_on_sessions_changed)


func add_element(session: Session) -> void:
	var session_info := session_info_scene.instantiate() as SessionInfo
	session_info.session = session
	session_info.selected.connect(_on_session_selected)
	container.call_deferred("add_child", session_info)


func clear() -> void:
	for child in container.get_children():
		child.queue_free()


func get_element_count() -> int:
	return container.get_child_count()


func _on_sessions_changed() -> void:
	var sessions := AppData.user_data.sessions
	if type == Type.PASSED:
		var passed_sessions := sessions.filter(func(sess: Session) -> bool: return DateUtil.is_date_before_today(sess.date))
		if passed_sessions.is_empty():
			empty_state.show()
			return
		empty_state.hide()
		for session: Session in passed_sessions:
			if not already_exists(session):
				add_element(session)
		for child: SessionInfo in container.get_children():
			if is_not_in(child.session, passed_sessions):
				child.queue_free()

	elif type == Type.UPCOMING:
		var upcoming_sessions := sessions.filter(func(sess: Session) -> bool: return !DateUtil.is_date_before_today(sess.date))
		if upcoming_sessions.is_empty():
			empty_state.show()
			return
		empty_state.hide()
		for session: Session in upcoming_sessions:
			if not already_exists(session):
				add_element(session)
		for child: SessionInfo in container.get_children():
			if is_not_in(child.session, upcoming_sessions):
				child.queue_free()


func already_exists(session: Session) -> bool:
	for child: SessionInfo in container.get_children():
		if child.session.id == session.id:
			return true
	return false


func is_not_in(session: Session, sessions: Array[Session]) -> bool:
	return session.id not in sessions.map(func(sess): return sess.id)


func is_sent_friendship(user_id: String, friendship: Friendship) -> bool:
	return friendship.status == Friendship.Status.PENDING and friendship.sender == user_id


func is_received_friendship(user_id: String, friendship: Friendship) -> bool:
	return friendship.status == Friendship.Status.PENDING and friendship.receiver == user_id


func is_friend(friendship: Friendship) -> bool:
	return friendship.status == Friendship.Status.ACCEPTED


func _on_session_selected(session_info: SessionInfo) -> void:
	session_selected.emit(session_info.session)
