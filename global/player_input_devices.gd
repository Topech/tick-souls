extends Node


var _player_device_lookup: Dictionary[Global.players, PlayerDevice] = {}

var keyb_assigned_to_player: bool = false


func get_players_device(player: Global.players) -> PlayerDevice:
	return _player_device_lookup.get(player, PlayerDevice.create_invalid(player))


func clear_player_device(player: Global.players) -> void:
	var player_device = get_players_device(player)

	if not player_device.is_invalid():
		_player_device_lookup.erase(player)

		if player_device.is_keyboard:
			PlayerInputDevices.keyb_assigned_to_player = false
		else:
			Global.joy_devices_detected = Global.joy_devices_detected.filter(
				func(x): return x != player_device.device_id
			)


func set_player_joy_device(player: Global.players, device_id: int) -> void:
	if player != Global.players.NO_PLAYER:
		var player_device = PlayerDevice.new(player, device_id)
		_player_device_lookup.set(player, player_device)


func set_player_keyb_device(player: Global.players) -> void:
	if player != Global.players.NO_PLAYER:
		var player_device = PlayerDevice.create_keyboard_device(player)
		_player_device_lookup.set(player, player_device)


func get_all_players() -> Array[Global.players]:
	var all_players = _player_device_lookup.keys()
	return all_players


func next_player() -> Variant:
	var assigned_players = get_all_players()
	var remaining_players = Global.all_possible_players.filter(
		func(x): return not assigned_players.has(x)
	)
	
	if not remaining_players.is_empty():
		remaining_players.sort()
		return remaining_players.front()
	else:
		return Global.players.NO_PLAYER
