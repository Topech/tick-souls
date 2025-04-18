extends Node2D


@onready var metrics = $PlayerMetrics.PlayerMetrics.new()
@onready var character_node = $MovementBody2d

# control nodes
@onready var input_direction_node = $MovementBody2d/InputDirection
@onready var control_simple_move_node = $MovementBody2d/ControlSimpleMove
@onready var player_control_roll = $MovementBody2d/PlayerControlRoll

# ability nodes
@onready var ability_suck_blood_node = $AbilitySuckBlood

# ui nodes
@onready var blood_bar = $MovementBody2d/BloodProgressBar
	


func _process(delta: float) -> void:
	# process movement and actions
	if not ability_suck_blood_node.sucking:
		control_simple_move_node.speed = metrics.speed
		control_simple_move_node.direction = input_direction_node.direction
		control_simple_move_node.move_node(delta)
	
	player_control_roll.roll_direction = input_direction_node.direction

	# abilities
	if not player_control_roll.rolling and ability_suck_blood_node.sucking:
		metrics.blood += ability_suck_blood_node.get_blood(delta)
	
	# update UI
	blood_bar.value = metrics.blood
