extends Node

var joy_devices_detected: Array[int] = []

enum players {
	NO_PLAYER=0,
	PLAYER_1=1,
	PLAYER_2,
	PLAYER_3,
	PLAYER_4
}

var all_possible_players = Array(Global.players.values()).filter(func(x): return x != Global.players.NO_PLAYER)


var player_names = {
	players.PLAYER_1: "Big Steve",
	players.PLAYER_2: "Lil Jimmy",
	players.PLAYER_3: "Sneaky Sammy",
	players.PLAYER_4: "Dingus Dirk"
}
