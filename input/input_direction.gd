extends Node

@export_category("Movement Actions")
@export var up_action: Enums.Actions = Enums.Actions.MOVE_UP
@export var down_action: Enums.Actions = Enums.Actions.MOVE_DOWN
@export var left_action: Enums.Actions = Enums.Actions.MOVE_LEFT
@export var right_action: Enums.Actions = Enums.Actions.MOVE_RIGHT

@export_category("Outputs")
@export var direction = Vector2(0, 0)


func _process(_delta: float) -> void:
	var new_direction = Vector2(0, 0)
	
	if Input.is_action_pressed(Enums.action_as_str(up_action)):
		new_direction += Vector2(0, -1)
	if Input.is_action_pressed(Enums.action_as_str(down_action)):
		new_direction += Vector2(0, 1)
	if Input.is_action_pressed(Enums.action_as_str(left_action)):
		new_direction += Vector2(-1, 0)
	if Input.is_action_pressed(Enums.action_as_str(right_action)):
		new_direction += Vector2(1, 0)
	
	direction = new_direction.normalized()
