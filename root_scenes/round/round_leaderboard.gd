extends Control


signal continue_pressed


## in secs
var round_duration: int


@onready var p1_name_label = $LabelList/P1Label/NameLabel
@onready var p2_name_label = $LabelList/P2Label/NameLabel
@onready var p3_name_label = $LabelList/P3Label/NameLabel
@onready var p4_name_label = $LabelList/P4Label/NameLabel

@onready var p1_score_label = $LabelList/P1Label/ScoreLabel
@onready var p2_score_label = $LabelList/P2Label/ScoreLabel
@onready var p3_score_label = $LabelList/P3Label/ScoreLabel
@onready var p4_score_label = $LabelList/P4Label/ScoreLabel

@onready var score_value = $RoundDurationLabel/RoundDurationValue


func _ready() -> void:
	p1_name_label.text = Global.player_details_lookup[Global.players.PLAYER_1].name
	p2_name_label.text = Global.player_details_lookup[Global.players.PLAYER_2].name
	p3_name_label.text = Global.player_details_lookup[Global.players.PLAYER_3].name
	p4_name_label.text = Global.player_details_lookup[Global.players.PLAYER_4].name
	
	p1_score_label.text = str(Global.player_details_lookup[Global.players.PLAYER_1].score)
	p2_score_label.text = str(Global.player_details_lookup[Global.players.PLAYER_2].score)
	p3_score_label.text = str(Global.player_details_lookup[Global.players.PLAYER_3].score)
	p4_score_label.text = str(Global.player_details_lookup[Global.players.PLAYER_4].score)

	score_value.text = str(round_duration) + " sec"


func _on_continue_button_pressed() -> void:
	continue_pressed.emit()
