class_name SectionWithLabel
extends VBoxContainer


@onready var container: VBoxContainer = %Container


func add_element(element: ScrollElement) -> void:
	container.call_deferred("add_child", element)
