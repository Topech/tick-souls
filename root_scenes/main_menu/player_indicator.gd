extends ColorRect


@export var player_id := Global.players.NO_PLAYER


func _process(delta: float) -> void:
	var player_device = PlayerInputDevices.get_players_device(player_id)
	if not player_device.is_invalid():
		color = Color.GREEN
