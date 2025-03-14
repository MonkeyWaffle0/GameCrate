class_name SessionInfo
extends ScrollElement


@onready var date: Label = %Date
@onready var session_owner: Label = %SessionOwner
@onready var participants: Label = %Participants

var session: Session


func _ready() -> void:
	super._ready()
	date.text = DateUtil.prettify_date(session.date)
	session_owner.text = session.owner_username
	if session.owner == AppData.get_user_id():
		session_owner.text += " (you)"
	var participants_except_owner := session.participants_usernames.filter(func(username: String): return username != session.owner_username)
	var result := ""
	for i: int in range(participants_except_owner.size()):
		result += str(participants_except_owner[i])
		if participants_except_owner[i] == AppData.user_data.username:
			result += " (you)"
		if i < participants_except_owner.size() - 1:
			result += ", "
	participants.text = result
