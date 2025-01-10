extends Node


var user_data: UserData


func _ready() -> void:
	Firebase.Auth.login_succeeded.connect(_on_login)
	

func _on_login(auth: Dictionary) -> void:
	user_data = await UserService.get_user_data()
