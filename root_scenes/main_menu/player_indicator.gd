extends ColorRect


@export var player_id := Global.players.NO_PLAYER


func _process(delta: float) -> void:
	var device_id = PlayerInputDevices.get_players_device(player_id)
	if device_id != PlayerInputDevices.INVALID_DEVICE:
		color = Color.GREEN
