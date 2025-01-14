class_name SelectionScrollContainer
extends ScrollContainer


@onready var container: VBoxContainer = %Container

var swiping = false
var swipe_start
var swipe_mouse_start
var swipe_mouse_times = []
var swipe_mouse_positions = []
var tween: Tween


func add_element(element: ScrollElement) -> void:
	container.call_deferred("add_child", element)
	element.selected.connect(_on_element_selected)


func clear() -> void:
	for child in container.get_children():
		child.queue_free()


func _on_element_selected(element: ScrollElement) -> void:
	for child: ScrollElement in container.get_children():
		child.set_selected(child == element)


func _input(ev):
	if ev is InputEventScreenTouch:
		if tween and tween.is_running():
			tween.kill()
		if ev.pressed:
			swiping = true
			swipe_start = Vector2(get_h_scroll(), get_v_scroll())
			swipe_mouse_start = ev.position
			swipe_mouse_times = [Time.get_ticks_msec()]
			swipe_mouse_positions = [swipe_mouse_start]
		else:
			swipe_mouse_times.append(Time.get_ticks_msec())
			swipe_mouse_positions.append(ev.position)
			var source = Vector2(get_h_scroll(), get_v_scroll())
			var idx = swipe_mouse_times.size() - 1
			var now = Time.get_ticks_msec()
			var cutoff = now - 100
			for i in range(swipe_mouse_times.size() - 1, -1, -1):
				if swipe_mouse_times[i] >= cutoff: idx = i
				else: break
			var flick_start = swipe_mouse_positions[idx]
			var flick_dur = min(0.3, (ev.position - flick_start).length() / 1000) * 25.0
			if flick_dur > 0.0:
				tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				var delta = ev.position - flick_start
				var target = source - delta * flick_dur * 15.0
				tween.tween_method(set_v_scroll, source.y, target.y, flick_dur)
			swiping = false
	elif swiping and ev is InputEventScreenDrag:
		if tween and tween.is_running():
			tween.kill()
		var delta = ev.position - swipe_mouse_start
		set_h_scroll(swipe_start.x - delta.x)
		set_v_scroll(swipe_start.y - delta.y)
		swipe_mouse_times.append(Time.get_ticks_msec())
		swipe_mouse_positions.append(ev.position)
