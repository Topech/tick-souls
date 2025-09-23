extends Control


signal continue_pressed


@onready var p1_label = $P1Label
@onready var p2_label = $P2Label
@onready var p3_label = $P3Label
@onready var p4_label = $P4Label


func _ready() -> void:
	p1_label.text[Global.player_names[Global.players.PLAYER_1]]
	p2_label.text[Global.player_names[Global.players.PLAYER_2]]
	p3_label.text[Global.player_names[Global.players.PLAYER_3]]
	p4_label.text[Global.player_names[Global.players.PLAYER_4]]


func _on_continue_button_pressed() -> void:
	continue_pressed.emit()
