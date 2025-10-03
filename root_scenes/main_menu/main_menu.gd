extends Control

signal start_game
signal start_boss


@onready var p1_label = $PlayerIndicator1/Label
@onready var p2_label = $PlayerIndicator2/Label
@onready var p3_label = $PlayerIndicator3/Label
@onready var p4_label = $PlayerIndicator4/Label

@onready var p1_sprite = $PlayerIndicator1/WiggleSprite
@onready var p2_sprite = $PlayerIndicator2/WiggleSprite
@onready var p3_sprite = $PlayerIndicator3/WiggleSprite
@onready var p4_sprite = $PlayerIndicator4/WiggleSprite

# this is for boss cheat code
var b_press_count = 0


func _process(_delta: float) -> void:
	var player_details_1 = Global.player_details_lookup[Global.players.PLAYER_1]
	var player_details_2 = Global.player_details_lookup[Global.players.PLAYER_2]
	var player_details_3 = Global.player_details_lookup[Global.players.PLAYER_3]
	var player_details_4 = Global.player_details_lookup[Global.players.PLAYER_4]

	p1_label.text = player_details_1.name + " - Ready?"
	p2_label.text = player_details_2.name + " - Ready?"
	p3_label.text = player_details_3.name + " - Ready?"
	p4_label.text = player_details_4.name + " - Ready?"

	p1_sprite.modulate = player_details_1.tinge
	p2_sprite.modulate = player_details_2.tinge
	p3_sprite.modulate = player_details_3.tinge
	p4_sprite.modulate = player_details_4.tinge

	if b_press_count >= 10:
		start_boss.emit()


func _on_button_pressed() -> void:
	if len(PlayerInputDevices.get_all_players()) > 0:
		start_game.emit()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu_skip_to_boss"):
		b_press_count += 1
