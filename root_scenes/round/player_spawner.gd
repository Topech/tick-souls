extends Node


@onready var player_container = $PlayerContainer


func _ready() -> void:
	for player_id in PlayerInputDevices.get_all_players():
		var player = preload("res://player/player.tscn").instantiate()
		player.player_id = player_id
		player.global_position = $PlayerSpawn1.global_position
		player_container.add_child(player)
