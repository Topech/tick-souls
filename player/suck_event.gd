extends PlayerEvent


func _input(event: InputEvent) -> void:
	if (
		player_device.check_owns_input(event) and
		event.is_action_pressed(
			Enums.action_as_str(Enums.Actions.ABILITY_SUCK_BLOOD)
		)
	):
		trigger()
	elif (
		player_device.check_owns_input(event) and
		event.is_action_released(Enums.action_as_str(Enums.Actions.ABILITY_SUCK_BLOOD))
	):
		clear()
