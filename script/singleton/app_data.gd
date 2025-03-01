extends Node


const USER_COLLECTION := "users"
const GAME_COLLECTION := "games"
const FRIEND_COLLECTION := "friends"
const FRIEND_SENT_COLLECTION := "friends_sent"
const FRIEND_RECEIVED_COLLECTION := "friends_received"
const SESSION_COLLECTION := "sessions"
const LIKES_COLLECTION := "likes"
const FRIENDSHIP_COLLECTION := "friendships"


var user_data := UserData.new()

var footer: Footer
var header: Header
var animated_background: AnimatedBackground


func get_user_id() -> String:
	return Firebase.Auth.auth["localid"]
