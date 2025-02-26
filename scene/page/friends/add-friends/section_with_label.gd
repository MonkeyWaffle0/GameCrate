class_name SectionWithLabel
extends VBoxContainer


@onready var container: VBoxContainer = %Container


func add_element(element: ScrollElement) -> void:
	container.call_deferred("add_child", element)


func clear() -> void:
	for child in container.get_children():
		child.queue_free()


func get_element_count() -> int:
	return container.get_child_count()
