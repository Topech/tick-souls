extends Node


@onready var player_container = $PlayerContainer

@onready var player_spawn_location = {
	Global.players.PLAYER_1: $PlayerSpawn1,
	Global.players.PLAYER_2: $PlayerSpawn2,
	Global.players.PLAYER_3: $PlayerSpawn3,
	Global.players.PLAYER_4: $PlayerSpawn4,
}


func _ready() -> void:
	for player_id in PlayerInputDevices.get_all_players():
		var player = preload("res://player/player.tscn").instantiate()
		player.player_id = player_id
		player.global_position = player_spawn_location[player_id].global_position
		player_container.add_child(player)
