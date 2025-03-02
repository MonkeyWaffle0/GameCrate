extends Node


const USER_COLLECTION := "users"
const GAME_COLLECTION := "games"
const SESSION_COLLECTION := "sessions"
const LIKES_COLLECTION := "likes"
const FRIENDSHIP_COLLECTION := "friendships"

var user_data := UserData.new()
var current_session: Session

var footer: Footer
var header: Header
var animated_background: AnimatedBackground


func get_user_id() -> String:
	return Firebase.Auth.auth["localid"]
