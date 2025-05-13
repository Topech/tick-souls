class_name ControllerDetector extends Node


func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton and not event.device in Global.devices_detected:
		Global.devices_detected.append(event.device)
		var player = PlayerInputDevices.next_player()
		PlayerInputDevices.set_players_device(player, event.device)
