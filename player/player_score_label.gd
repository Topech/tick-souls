class_name PlayerScoreLabel extends HBoxContainer


@export var player_id = Global.players.NO_PLAYER

@onready var name_label = $NameLabel
@onready var score_label = $ScoreLabel


func _ready() -> void:
	visible = false
	# yes this is very efficient
	for id in PlayerInputDevices.get_all_players():
		if id == player_id:
			visible = true
			var player_details: Global.PlayerDetails = Global.player_details_lookup[player_id]
			modulate = player_details.tinge


func _process(_delta: float) -> void:
	var player_details: Global.PlayerDetails = Global.player_details_lookup[player_id]
	name_label.text = player_details.name
	score_label.text = str(round(player_details.score))
	
