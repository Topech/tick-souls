extends PlayerEvent

@onready var input_direction_node = $InputDirection
@onready var direction: Vector2 = input_direction_node.direction


func _process(delta: float) -> void:
	direction = input_direction_node.direction
	if not direction.is_zero_approx():
		trigger()
	else:
		clear()
