extends PlayerEvent


var input_direction_node: Node
var direction: Vector2 = Vector2.ZERO


func _ready():
	super._ready()
	input_direction_node = $InputDirection
	input_direction_node.device_id = player_device.device_id


func _process(_delta: float) -> void:
	direction = input_direction_node.direction
	if not direction.is_zero_approx():
		trigger()
	else:
		clear()
