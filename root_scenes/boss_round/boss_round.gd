extends Node2D


signal round_ended


@onready var player_container = $PlayerSpawner/PlayerContainer


## in secs
var round_duration: int = 0

var prev_boss_health_bar: float = 0.0;
var suck_current_intensity: float = 0.1;
var is_sucking: bool = false;
const suck_increase_rate: float = 2;


func _ready() -> void:
	# spawn first one early
	$TweezerSpawnTimer.wait_time = 1
	$TweezerSpawnTimer.start()
	$TweezerSpawnTimer.wait_time = 10


func _process(_delta: float) -> void:
	if len(player_container.get_all_players()) == 0:
		round_ended.emit(false)
	elif $Boss.health_bar.value <= 0:
		round_ended.emit(true)
		
	if is_sucking == true:
		suck_current_intensity = suck_current_intensity + (suck_increase_rate * _delta);
	else:
		suck_current_intensity = 0.1

	if prev_boss_health_bar != $Boss.health_bar.value:
		is_sucking = true;
		var players = player_container.get_all_players();
		for player in players:
			if player.state == player.states.SUCKING:
				$Camera2D.start_shake(0.1, suck_current_intensity)
				break;
	else:
		is_sucking = false;
	prev_boss_health_bar = $Boss.health_bar.value


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
