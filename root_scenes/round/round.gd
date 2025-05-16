extends Node2D


@onready var player_container = $PlayerSpawner/PlayerContainer


func _ready() -> void:
	$TweezerSpawnTimer.wait_time = 5
	$TweezerSpawnTimer.start()


func _on_tweezers_tweezed_player(player: Player) -> void:
	player.tweeze()


func _on_tweezers_failed(tweezer: Tweezers) -> void:
	tweezer.queue_free()


func _on_timer_timeout() -> void:
	var tweezers = preload("res://tweezers/tweezers.tscn").instantiate()
	var player_id = PlayerInputDevices.get_all_players()[
		round(randf() * len(PlayerInputDevices.get_all_players()) - 1)
	]
	tweezers.target_node = $PlayerSpawner/PlayerContainer.get_player_by_id(player_id)
	add_child(tweezers)
	tweezers.failed.connect(_on_tweezers_failed)
	$TweezerSpawnTimer.wait_time = 10
	#$TweezerSpawnTimer.start()
