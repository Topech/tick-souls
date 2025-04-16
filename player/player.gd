extends Node2D


@onready var metrics = $PlayerMetrics.PlayerMetrics.new()
@onready var character_node = $CharacterBody2D

# control nodes
@onready var input_direction_node = $CharacterBody2D/InputDirection
@onready var control_simple_move_node = $CharacterBody2D/ControlSimpleMove
@onready var player_control_roll = $CharacterBody2D/PlayerControlRoll


func _process(delta: float) -> void:
	control_simple_move_node.speed = metrics.speed
	control_simple_move_node.direction = input_direction_node.direction
	player_control_roll.roll_direction = input_direction_node.direction

	control_simple_move_node.move_node(delta)
	
