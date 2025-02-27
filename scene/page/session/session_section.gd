class_name SessionSection
extends VBoxContainer


enum Type { UPCOMING, PASSED }

@export var type: Type
@export var session_info_scene: PackedScene

@onready var container: VBoxContainer = %Container
