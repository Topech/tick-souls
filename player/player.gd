extends Node2D


@onready var metrics = $PlayerMetrics.PlayerMetrics.new()

# control nodes
@onready var input_direction_node = $InputDirection
@onready var control_simple_move_node = $ControlSimpleMove
@onready var player_control_roll = $PlayerControlRoll
@onready var roll_effect_node = $RollEffect
@onready var move_effect_node = $MoveEffect
@onready var suck_effect_node = $SuckEffect


# ui nodes
@onready var blood_bar = $BloodProgressBar


func _input(event: InputEvent) -> void:
	if (
		 event.is_action_pressed(Enums.action_as_str(Enums.Actions.MOVE_ROLL))
	):
		if (
			roll_effect_node.enabled 
			and not suck_effect_node.triggered
			and not roll_effect_node.triggered
		):
			roll_effect_node.trigger()


func _process(delta: float) -> void:
	# process inputs
	if (
		move_effect_node.enabled
		and not suck_effect_node.triggered
		and not input_direction_node.direction.is_zero_approx()
	):
		move_effect_node.trigger()
	else:
		move_effect_node.cancel()
	
	if (
		suck_effect_node.enabled
		and not roll_effect_node.triggered
		and Input.is_action_just_pressed(Enums.action_as_str(Enums.Actions.ABILITY_SUCK_BLOOD))
	):
		suck_effect_node.trigger()
	elif Input.is_action_just_released(Enums.action_as_str(Enums.Actions.ABILITY_SUCK_BLOOD)):
		suck_effect_node.cancel()
	
	# process effects
	move_effect_node.speed = metrics.speed
	move_effect_node.direction = input_direction_node.direction
	
	roll_effect_node.roll_direction = input_direction_node.direction

	if suck_effect_node.triggered:
		const BLOOD_PER_SEC = 10
		metrics.blood += BLOOD_PER_SEC * delta

	# update UI
	blood_bar.value = metrics.blood
