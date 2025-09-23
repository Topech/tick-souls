extends Control

signal start_game


@onready var p1_label = $PlayerIndicator1/Label
@onready var p2_label = $PlayerIndicator2/Label
@onready var p3_label = $PlayerIndicator3/Label
@onready var p4_label = $PlayerIndicator4/Label


func _ready() -> void:
	p1_label.text = Global.player_names[Global.players.PLAYER_1] + " - Ready?"
	p2_label.text = Global.player_names[Global.players.PLAYER_2] + " - Ready?"
	p3_label.text = Global.player_names[Global.players.PLAYER_3] + " - Ready?"
	p4_label.text = Global.player_names[Global.players.PLAYER_4] + " - Ready?"


func _on_button_pressed() -> void:
	if len(PlayerInputDevices.get_all_players()) > 0:
		start_game.emit()
