class_name BoardGameInfo
extends Control


@onready var game_name: Label = %GameName
@onready var players: Label = %Players
@onready var year: Label = %Year
@onready var playtime: Label = %Playtime
@onready var weight: Label = %Weight
@onready var url_texture_rect: UrlTextureRect = %UrlTextureRect

var board_game: BoardGame


func _ready() -> void:
	players.text = ""
	playtime.text = ""
	weight.text = ""
	game_name.text = board_game.game_name
	year.text = board_game.year_published
	board_game.changed.connect(_on_changed)


func _on_changed() -> void:
	game_name.text = board_game.game_name
	year.text = board_game.year_published
	if board_game.max_player != 0:
		if board_game.max_player == board_game.min_player:
			players.text = str(board_game.min_player)
		else:
			players.text = "%s-%s" % [board_game.min_player, board_game.max_player]
	if board_game.playtime != 0:
		playtime.text = "%s min" % [board_game.playtime]
	if board_game.weight != 0:
		weight.text = "%0.2f" % [board_game.weight]
	if not board_game.image_url.is_empty():
		url_texture_rect.load_image(board_game.image_url)
