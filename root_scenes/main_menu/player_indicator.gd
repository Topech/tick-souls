extends ColorRect


@export var player_id := Global.players.NO_PLAYER

@onready var wiggle_sprite = $WiggleSprite


var disabled_color := Color.hex(0x707070)


func _ready():
	color = disabled_color
	wiggle_sprite.visible = false


func _process(delta: float) -> void:
	var player_device = PlayerInputDevices.get_players_device(player_id)
	if not player_device.is_invalid():
		color = Color.GREEN
		wiggle_sprite.visible = true
	else:
		color = disabled_color
		wiggle_sprite.visible = false


func _input(event: InputEvent) -> void:
	var player_device = PlayerInputDevices.get_players_device(player_id)
	if (
		not player_device.is_invalid()
		and player_device.check_owns_input(event)
		and event.is_action_pressed("ui_accept")
	):
		var new_name = PlayerNames.choose_random_name()
		if new_name in Global.player_details_lookup.values().map(func(x): return x.name):
			new_name = "same old " + new_name
		Global.player_details_lookup[player_id].name = new_name
	elif (
		not player_device.is_invalid()
		and player_device.check_owns_input(event)
		and event.is_action_pressed("ui_cancel")
	):
		PlayerInputDevices.clear_player_device(player_id)
