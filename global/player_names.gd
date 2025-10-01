extends Node


var player_name_options = [
	"Big Steve",
	"Lil Jimmy",
	"Sneaky Sammy",
	"Dingus Dirk",
	"Parasite Paul",
	"Arachnid Aaron",
	"Blong Schmungus",
	"Blong Bloodsucker",
	"Anticoagulant Amanda",
	"Questing kaylee",
	"Amblyomma Abby",
]


func choose_random_name() -> String:
	var random_index = randi_range(0, len(player_name_options) - 1)
	return player_name_options[random_index]
