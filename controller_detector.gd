class_name ControllerDetector extends Node


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if event is InputEventJoypadButton and not event.device in Global.joy_devices_detected:
			Global.joy_devices_detected.append(event.device)
			var player = PlayerInputDevices.next_player()
			if player != Global.players.NO_PLAYER:
				PlayerInputDevices.set_player_joy_device(player, event.device)
		
		elif event is InputEventKey and not PlayerInputDevices.keyb_assigned_to_player:
			PlayerInputDevices.keyb_assigned_to_player =  true
			var player = PlayerInputDevices.next_player()
			if player != Global.players.NO_PLAYER:
				PlayerInputDevices.set_player_keyb_device(player)
