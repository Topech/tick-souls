extends PlayerEffect


@export_group("Target Nodes")
@export var target_move_node: CharacterBody2D
@export var target_rotate_node: Node2D

@export_group("Parameters")
@export var roll_direction: Vector2
@export var roll_speed: int = 300
## Cooldown in seconds
@export var roll_cooldown_duration: float = 1


var is_in_cooldown: bool = false
var locked_roll_direction: Vector2
var locked_roll_speed: int
@onready var roll_timer = $RollTimer
@onready var roll_cooldown_timer = $RollCooldownTimer


func activate():
	if (not is_in_cooldown and not roll_direction.is_zero_approx()):
		locked_roll_direction = roll_direction.normalized()
		locked_roll_speed = roll_speed
		roll_timer.start()
		super.activate()


func deactivate():
	target_rotate_node.rotation = 0
	super.deactivate()


func apply(_delta: float):
	if not is_in_cooldown:
		var timer_percent_complete = (roll_timer.wait_time - roll_timer.time_left) * 1 / roll_timer.wait_time
		var new_rotation = timer_percent_complete * 720
		var is_rolling_right = locked_roll_direction.x > 0
		if (not is_rolling_right):
			new_rotation *= -1
		target_rotate_node.rotation_degrees = new_rotation

		target_move_node.velocity = locked_roll_direction * locked_roll_speed
		target_move_node.move_and_slide()


func _start_cooldown() -> void:
	is_in_cooldown = true
	roll_cooldown_timer.start(roll_cooldown_duration)


func _stop_cooldown() -> void:
	is_in_cooldown = false


func _on_roll_timer_timeout() -> void:
	target_rotate_node.rotation = 0
	_start_cooldown()
	deactivate()


func _on_roll_cooldown_timer_timeout() -> void:
	_stop_cooldown()
