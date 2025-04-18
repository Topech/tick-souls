extends Node

@export_category("Affected Nodes")
@export var node_to_move: Node2D
@export var node_to_rotate: Node2D

@export_category("Parameters")
@export var roll_direction: Vector2
@export var roll_speed: int = 300


@onready var roll_timer = $RollTimer

var rolling = false
var locked_roll_direction: Vector2


func _input(event: InputEvent) -> void:
	if (
		not rolling
		and not node_to_move.velocity.is_zero_approx()
		and event.is_action_pressed(Enums.action_as_str(Enums.Actions.MOVE_ROLL))
	):
		locked_roll_direction = roll_direction
		rolling = true
		roll_timer.start()


func _process(delta: float) -> void:
	if rolling:
		roll_node()


func roll_node():
	var timer_percent_complete = (roll_timer.wait_time - roll_timer.time_left) * 1 / roll_timer.wait_time
	node_to_rotate.rotation_degrees = timer_percent_complete * 720
	
	node_to_move.velocity = locked_roll_direction.normalized() * roll_speed
	node_to_move.move_and_slide()


func _on_roll_timer_timeout() -> void:
	rolling = false
	node_to_rotate.rotation_degrees = 0
