extends CanvasLayer


@export var notification_scene: PackedScene

var queue: Array[NotificationData] = []
var is_playing_notification := false


func add_notification(notification_data: NotificationData) -> void:
	queue.append(notification_data)
	if not is_playing_notification:
		show_next_notification()


func show_next_notification() -> void:
	if len(queue) == 0:
		is_playing_notification = false
		return

	is_playing_notification = true
	var next_notification_data := queue[0]
	var notification_node := NodeUtil.instance_scene(notification_scene, self) as Notification
	notification_node.notification_data = next_notification_data
	notification_node.finished.connect(func():
		await get_tree().create_timer(0.5).timeout
		show_next_notification())
	queue.pop_front()
