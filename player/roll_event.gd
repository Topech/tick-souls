extends PlayerEvent

#@export var device_id: int


func _input(event: InputEvent) -> void:
	if (
		# event.device == device_id and
		 event.is_action_pressed(Enums.action_as_str(Enums.Actions.MOVE_ROLL))
	):
		trigger()
	else:
		clear()
