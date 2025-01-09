class_name NodeUtil
extends Node


static func instance_scene_at_location(node: PackedScene, parent: Node, location: Vector3, rotation := Vector3.ZERO) -> Node:
	var node_instance = instance_scene(node, parent)
	node_instance.set_deferred("global_position", location)
	if node_instance is Node3D or node_instance is Node2D:
		node_instance.rotation = rotation
	return node_instance
	

static func instance_2d_scene_at_location(node: PackedScene, parent: Node, location: Vector2, rotation := 0.0) -> Node:
	var node_instance = instance_scene(node, parent)
	node_instance.set_deferred("global_position", location)
	if node_instance is Node2D:
		node_instance.rotation = rotation
	return node_instance


static func instance_scene(scene: PackedScene, parent: Node) -> Node:
	var node_instance := scene.instantiate()
	parent.call_deferred("add_child", node_instance)
	return node_instance
