class_name Friendship
extends Resource


enum Status { PENDING, ACCEPTED }

var id: String
var sender: String
var receiver: String
var participants: Array[String]
var status: String
