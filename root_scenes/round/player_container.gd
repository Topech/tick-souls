extends Node


func get_player_by_id(player_id: Global.players) -> Variant:
	for child in get_children():
		if child is Player and child.player_id == player_id:
			return child
	return null


func get_all_players() -> Array[Player]:
	var all_players: Array[Player] = []
	for child in get_children():
		if child is Player:
			all_players.append(child)
	return all_players


func choose_random_player() -> Player:
	var players = get_all_players()
	if len(players) == 0:
		return null
	var player = players[
		round(randf() * len(players) - 1)
	]
	return player
