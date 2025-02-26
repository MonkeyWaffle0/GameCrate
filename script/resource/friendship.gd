class_name Friendship
extends Resource


enum Status { PENDING, REJECTED, ACCEPTED, DELETED, ERROR }

var id: String
var sender: String
var receiver: String
var participants: Array[String]
var status: Status


func _init(_id: String, _sender: String, _receiver: String, _status: Status) -> void:
	self.id = _id
	self.sender = _sender
	self.receiver = _receiver
	self.participants = [sender, receiver]
	self.status = _status


func to_dict() -> Dictionary:
	return {
		"sender": sender,
		"receiver": receiver,
		"participants": participants,
		"status": status_to_string(status)
	}


static func from_dict(data: Dictionary) -> Friendship:
	return Friendship.new(data["id"], data["sender"], data["receiver"], string_to_status(data["status"]))


static func status_to_string(_status: Status) -> String:
	match _status:
		Status.PENDING: return "PENDING"
		Status.REJECTED: return "REJECTED"
		Status.ACCEPTED: return "ACCEPTED"
		Status.DELETED: return "DELETED"
	printerr("Can not convert Friendship.Status %s to String" % [_status])
	return ""


static func string_to_status(_status: String) -> Status:
	match _status:
		"PENDING": return Status.PENDING
		"REJECTED": return Status.REJECTED
		"ACCEPTED": return Status.ACCEPTED
		"DELETED": return Status.DELETED
	printerr("Can not convert %s to Friendship.Status" % [_status])
	return Status.ERROR


func _to_string() -> String:
	return "<Friendship> id: %s, sender: %s, receiver: %s, status: %s" % [id, sender, receiver, status_to_string(status)]
