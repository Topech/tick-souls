extends Node


const INVALID_DEVICE = 120


var _player_device_lookup = {}


func get_players_device(player: Global.players) -> int:
	return _player_device_lookup.get(player, INVALID_DEVICE)


func set_players_device(player: Global.players, device_id: int) -> void:
	if player != Global.players.NO_PLAYER:
		_player_device_lookup.set(player, device_id)


func next_player() -> Variant:
	var assigned_players = _player_device_lookup.keys()
	var remaining_players = Global.all_players.filter(func(x): return not assigned_players.has(x))
	
	if not remaining_players.is_empty():
		remaining_players.sort()
		return remaining_players.front()
	else:
		return Global.players.NO_PLAYER


func get_all_players() -> Array:
	var all_players = _player_device_lookup.keys()
	return all_players
