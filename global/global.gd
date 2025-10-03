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
	## the color to apply
	var tinge: Color

	func _init(name_: String, tinge_: Color) -> void:
		self.name = name_
		self.tinge = tinge_
		


var player_details_lookup = {
	players.PLAYER_1: PlayerDetails.new("Big Steve", Color.hex(0x99e900FF)),
	players.PLAYER_2: PlayerDetails.new("Lil Jimmy", Color.hex(0xffbaa9FF)),
	players.PLAYER_3: PlayerDetails.new("Sneaky Sammy", Color.hex(0x93d9f7FF)),
	players.PLAYER_4: PlayerDetails.new("Dingus Dirk", Color.hex(0xded300FF)),
}


enum SuckStrategyType {
	STANDARD,
	BOSS,
}
