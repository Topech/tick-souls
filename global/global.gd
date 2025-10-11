extends Node

var joy_devices_detected: Array[int] = []

enum players {
	NO_PLAYER=0,
	PLAYER_1=1,
	PLAYER_2,
	PLAYER_3,
	PLAYER_4
}

var all_possible_players = (
	Array(
		players.values()
	).filter(func(x): return x != players.NO_PLAYER)
	as Array[players]
)


class PlayerDetails:
	var score: float = 0
	var name: String
	## the color to apply
	var tinge: Color

	func _init(name_: String, tinge_: Color) -> void:
		self.name = name_
		self.tinge = tinge_
		


var player_details_lookup = {
	players.PLAYER_1: PlayerDetails.new("Big Steve", Color.hex(0xff0000FF)),
	players.PLAYER_2: PlayerDetails.new("Lil Jimmy", Color.hex(0xeeff00FF)),
	players.PLAYER_3: PlayerDetails.new("Sneaky Sammy", Color.hex(0x37ff00FF)),
	players.PLAYER_4: PlayerDetails.new("Dingus Dirk", Color.hex(0x2b72ffFF)),
}


func clear_all_player_scores():
	for player_details in player_details_lookup.values():
		player_details.score = 0


enum SuckStrategyType {
	STANDARD,
	BOSS,
}
