extends PlayerEffect

@export_group("Target Node")
@export var target_rotate_node: Node2D


func apply(_delta: float):
	target_rotate_node.rotation_degrees = 180


func deactivate():
	target_rotate_node.rotation_degrees = 0
	super.deactivate()
