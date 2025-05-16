extends PlayerEvent


var device_id: int = PlayerInputDevices.INVALID_DEVICE


func _ready() -> void:
	var player: Player = owner
	var players_device_id = player.device_id
	device_id = players_device_id


func _input(event: InputEvent) -> void:
	if (
		 event.device == device_id and
		 event.is_action_pressed(Enums.action_as_str(Enums.Actions.MOVE_ROLL))
	):
		trigger()
	else:
		clear()
