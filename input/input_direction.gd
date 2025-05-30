extends Node


var device_id: int


@export_group("Movement Actions")
@export var up_action: Enums.Actions = Enums.Actions.MOVE_UP
@export var down_action: Enums.Actions = Enums.Actions.MOVE_DOWN
@export var left_action: Enums.Actions = Enums.Actions.MOVE_LEFT
@export var right_action: Enums.Actions = Enums.Actions.MOVE_RIGHT

@export_group("Outputs")
@export var direction = Vector2(0, 0)


var up_strength: float = 0
var down_strength: float = 0
var left_strength: float = 0
var right_strength: float = 0


func _input(event: InputEvent) -> void:
	if event.device != device_id:
		return
	
	match event:
		InputEventKey:
			if event.is_action_pressed(Enums.action_as_str(up_action)):
				up_strength = 1.0
			if event.is_action_pressed(Enums.action_as_str(down_action)):
				down_strength = 1.0
			if event.is_action_pressed(Enums.action_as_str(left_action)):
				left_strength = 1.0
			if event.is_action_pressed(Enums.action_as_str(right_action)):
				right_strength = 1.0
		
		#InputEventJoypadMotion:
	if event.is_action(Enums.action_as_str(up_action)):
		up_strength = event.get_action_strength(Enums.action_as_str(up_action))
	if event.is_action(Enums.action_as_str(down_action)):
		down_strength = event.get_action_strength(Enums.action_as_str(down_action))
	if event.is_action(Enums.action_as_str(left_action)):
		left_strength = event.get_action_strength(Enums.action_as_str(left_action))
	if event.is_action(Enums.action_as_str(right_action)):
		right_strength = event.get_action_strength(Enums.action_as_str(right_action))
	

func _process(_delta: float) -> void:
	var new_direction = Vector2(0, 0)
	
	direction = Vector2(right_strength - left_strength, down_strength - up_strength)
