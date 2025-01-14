class_name Notification
extends PanelContainer


signal finished

const ERROR_TEXTURE := preload("res://asset/icon/error.svg")
const CHECKMARK_TEXTURE := preload("res://asset/icon/checkmark.svg")
const ERROR_COLOR := Color("#FF1C1C")
const SUCCESS_COLOR := Color("#4ea699")

@onready var texture_rect: TextureRect = %TextureRect
@onready var label: Label = %Label
@onready var icon_margin: MarginContainer = %IconMargin

var notification_data: NotificationData


func _ready() -> void:
	match notification_data.type:
		NotificationData.NotificationType.SUCCESS:
			texture_rect.texture = CHECKMARK_TEXTURE
			label.add_theme_color_override("font_color", SUCCESS_COLOR)
		NotificationData.NotificationType.ERROR:
			icon_margin.add_theme_constant_override("margin_top", 4)
			icon_margin.add_theme_constant_override("margin_bottom", 4)
			icon_margin.add_theme_constant_override("margin_left", 4)
			icon_margin.add_theme_constant_override("margin_right", 4)
			texture_rect.texture = ERROR_TEXTURE
			label.add_theme_color_override("font_color", ERROR_COLOR)
	label.text = notification_data.text

	position.y += 64
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position:y", position.y - 128, 0.2)
	await tween.finished
	await get_tree().create_timer(2.0).timeout
	tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position:y", position.y + 128, 0.2)
	await tween.finished
	finished.emit()
	queue_free()
