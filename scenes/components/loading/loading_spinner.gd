class_name LoadingSpinner
extends TextureProgressBar


func _ready() -> void:
	await get_tree().process_frame
	pivot_offset = size / 2
	while true:
		await animation()


func animation() -> void:
	fill_mode = FILL_CLOCKWISE
	var in_tween := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	in_tween.tween_property(self, "value", 100, 0.75)
	await in_tween.finished
	fill_mode = FILL_COUNTER_CLOCKWISE
	var out_tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	out_tween.tween_property(self, "value", 1, 1.0)
	await out_tween.finished
	

func _process(delta: float) -> void:
	rotation += delta * 3.0


func _on_visibility_changed() -> void:
	if visible:
		await get_tree().process_frame
		pivot_offset = size / 2
