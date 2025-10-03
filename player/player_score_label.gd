class_name PlayerScoreLabel extends HBoxContainer


@export var player_id = Global.players.NO_PLAYER

@onready var name_label = $NameLabel
@onready var score_label = $ScoreLabel


func _process(_delta: float) -> void:
	var player_details: Global.PlayerDetails = Global.player_details_lookup[player_id]
	name_label.text = player_details.name
	score_label.text = str(round(player_details.score))
	
