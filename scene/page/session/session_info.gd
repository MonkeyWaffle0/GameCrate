class_name SessionInfo
extends ScrollElement


@onready var date: Label = %Date
@onready var session_owner: Label = %SessionOwner
@onready var participants: Label = %Participants

var session: Session


func _ready() -> void:
	date.text = DateUtil.prettify_date(session.date)
	session_owner.text = session.owner_username
	if session.owner == AppData.get_user_id():
		session_owner.text += " (you)"
	var other_usernames := session.participants_usernames.filter(func(username: String): return username != AppData.user_data.username)
	var result := ""
	for i: int in range(other_usernames.size()):
		result += str(other_usernames[i])
		if i < other_usernames.size() - 1:
			result += ", "
	participants.text = result
