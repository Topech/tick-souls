extends Node

var joy_devices_detected: Array[int] = []

enum players {
	NO_PLAYER=0,
	PLAYER_1=1,
	PLAYER_2,
	PLAYER_3,
	PLAYER_4
}

var all_possible_players = Array(players.values()).filter(func(x): return x != players.NO_PLAYER)


class PlayerDetails:
	var score: float = 0
	var name: String

	func _init(name_: String) -> void:
		self.name = name_


var player_details_lookup = {
	players.PLAYER_1: PlayerDetails.new("Big Steve"),
	players.PLAYER_2: PlayerDetails.new("Lil Jimmy"),
	players.PLAYER_3: PlayerDetails.new("Sneaky Sammy"),
	players.PLAYER_4: PlayerDetails.new("Dingus Dirk")
}


enum SuckStrategyType {
	STANDARD,
	BOSS,
}
