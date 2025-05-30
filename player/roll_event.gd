extends PlayerEvent


func _input(event: InputEvent) -> void:
	if (
		 player_device.check_owns_input(event) and
		 event.is_action(Enums.action_as_str(Enums.Actions.MOVE_ROLL))
	):
		trigger()
