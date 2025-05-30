extends Node

var devices_detected: Array[int] = []

enum players {
	NO_PLAYER=0,
	PLAYER_1=1,
	PLAYER_2,
	PLAYER_3,
	PLAYER_4
}

var all_possible_players = Array(Global.players.values()).filter(func(x): return x != Global.players.NO_PLAYER)
