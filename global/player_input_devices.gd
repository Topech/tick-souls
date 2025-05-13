extends Node


var _player_device_lookup = {}


func get_players_device(player: Global.players) -> Variant:
	return _player_device_lookup.get(player, null)


func set_players_device(player: Global.players, device_id: int) -> void:
	_player_device_lookup.set(player, device_id)


func next_player() -> Variant:
	#var assigned_players = _player_device_lookup.keys()
	#var all_players = Array(Global.players.values())
	#var remaining_players = all_players.filter(func(x): not assigned_players.has(Global.players.)
	#
	#print(assigned_players)
	#print(Global.players.values())
	#print(remaining_players)
	#
	#remaining_players.sort()
	#return remaining_players.front()
	return Global.players.PLAYER_1
