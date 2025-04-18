extends Node


@export var node_to_visualise: Node2D


var sucking = false

		
func _process(delta: float) -> void:
	if Input.is_action_pressed("ability_suck_blood"):
		sucking = true
		node_to_visualise.rotation_degrees = 180
	elif Input.is_action_just_released("ability_suck_blood"):
		node_to_visualise.rotation_degrees = 0
		sucking = false
	else:
		sucking = false
		


func get_blood(delta: float):
	if sucking:
		const BLOOD_PER_SEC = 10
		return BLOOD_PER_SEC * delta
	return 0
