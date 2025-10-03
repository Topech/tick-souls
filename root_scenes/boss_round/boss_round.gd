extends Node2D

@onready var player_container = $PlayerSpawner/PlayerContainer


## in secs
var round_duration: int = 0


func _ready() -> void:
	# spawn first one early
	$TweezerSpawnTimer.wait_time = 1
	$TweezerSpawnTimer.start()
	$TweezerSpawnTimer.wait_time = 10


func _on_tweezers_tweezed_player(player: Player) -> void:
	player.tweeze()

	# give time to delete player so it can go off screen
	var timer = get_tree().create_timer(3.0)
	timer.timeout.connect(func():
		if player != null:
			player.queue_free()
	)


func _on_tweezers_failed(tweezer: Tweezers) -> void:
	tweezer.queue_free()


func _on_tweezer_spawn_timer_timeout() -> void:
	var tweezers = preload("res://tweezers/tweezers.tscn").instantiate()
	tweezers.target_node = player_container.choose_random_player()
	
	var screen_size = get_viewport().get_visible_rect().size
	tweezers.position = Vector2(
		screen_size.x * randf(),
		screen_size.y * randf(),
	)
	add_child(tweezers)
	tweezers.tweezed_player.connect((_on_tweezers_tweezed_player))
	tweezers.failed.connect(_on_tweezers_failed)
	const min_spawn_rate = 0.5
	const max_spawn_rate = 10.0
	const secs_until_max_spawn_rate = 120.0
	var new_wait_time = max(
		min_spawn_rate,
		max_spawn_rate - (max_spawn_rate - min_spawn_rate) * (float(round_duration) / secs_until_max_spawn_rate)
	)
	$TweezerSpawnTimer.wait_time = new_wait_time


func _on_round_timer_timeout() -> void:
	round_duration += 1
