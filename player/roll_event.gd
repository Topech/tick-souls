extends PlayerEvent


func _input(event: InputEvent) -> void:
	if (
		event.is_action_pressed(Enums.action_as_str(Enums.Actions.MOVE_ROLL))
	):
		trigger()
	else:
		clear()
