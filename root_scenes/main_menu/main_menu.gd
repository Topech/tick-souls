extends Control

signal start_game


@onready var p1_label = $PlayerIndicator1/Label
@onready var p2_label = $PlayerIndicator2/Label
@onready var p3_label = $PlayerIndicator3/Label
@onready var p4_label = $PlayerIndicator4/Label


func _process(_delta: float) -> void:
	p1_label.text = Global.player_details_lookup[Global.players.PLAYER_1].name + " - Ready?"
	p2_label.text = Global.player_details_lookup[Global.players.PLAYER_2].name + " - Ready?"
	p3_label.text = Global.player_details_lookup[Global.players.PLAYER_3].name + " - Ready?"
	p4_label.text = Global.player_details_lookup[Global.players.PLAYER_4].name + " - Ready?"


func _on_button_pressed() -> void:
	if len(PlayerInputDevices.get_all_players()) > 0:
		start_game.emit()
