extends PlayerEffect

@export_group("Target Node")
@export var target_rotate_node: Node2D


func apply(delta: float):
	target_rotate_node.rotation_degrees = 180


func cancel():
	target_rotate_node.rotation_degrees = 0
