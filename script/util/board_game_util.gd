class_name BoardGameUtil
extends Node


static func sort(array: Array[BoardGame], reference: String) -> void:
	array.sort_custom(func(a, b): return _compare(a, b, reference.to_lower()))


static func _compare(a: BoardGame, b: BoardGame, reference: String) -> bool:
	var a_name := a.game_name.to_lower()
	var b_name := b.game_name.to_lower()
	
	if a_name == reference and b_name != reference:
		return true
	elif b_name == reference and a_name != reference:
		return false
	elif a_name == reference and b_name == reference:
		return int(a.year_published) > int(b.year_published)
	else:
		return false
