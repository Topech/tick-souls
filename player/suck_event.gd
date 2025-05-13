extends PlayerEvent

#var device_id: int
#
#
#func _ready() -> void:
	#var player: Player = owner
	#device_id = PlayerInputDevices.get_players_device(player.player_id)


func _input(event: InputEvent) -> void:
	if (
		# event.device == device_id and 
		event.is_action_pressed(
			Enums.action_as_str(Enums.Actions.ABILITY_SUCK_BLOOD)
		)
	):
		trigger()
	elif event.is_action_released(Enums.action_as_str(Enums.Actions.ABILITY_SUCK_BLOOD)):
		clear()
