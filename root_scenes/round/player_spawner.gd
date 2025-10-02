extends Node

## hacky solution to quickly create boss round players
@export var is_boss_round: bool = false


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
		if is_boss_round:
			player.suck_strategy_type = Global.SuckStrategyType.BOSS
		player_container.add_child(player)
