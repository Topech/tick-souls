extends Node


var _player_device_lookup = {}


func get_players_device(player: Global.players) -> PlayerDevice:
	return _player_device_lookup.get(player, PlayerDevice.create_invalid(player))


func set_players_device(player: Global.players, device_id: int) -> void:
	if player != Global.players.NO_PLAYER:
		var player_device = PlayerDevice.new(player, device_id)
		_player_device_lookup.set(player, player_device)


func get_all_players() -> Array:
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
