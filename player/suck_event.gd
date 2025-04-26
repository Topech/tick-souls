extends PlayerEvent


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(
		Enums.action_as_str(Enums.Actions.ABILITY_SUCK_BLOOD)
	):
		trigger()
	elif event.is_action_released(Enums.action_as_str(Enums.Actions.ABILITY_SUCK_BLOOD)):
		clear()
