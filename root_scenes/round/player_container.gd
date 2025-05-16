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
