extends Node2D


signal round_ended


@onready var player_container = $PlayerSpawner/PlayerContainer
@onready var boss_audio = $BossAudio

## in secs
var round_duration: int = 0
var stage_duration: int = 0

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

	if is_sucking == true:
		suck_current_intensity = suck_current_intensity + (suck_increase_rate * _delta);
	else:
		suck_current_intensity = 0.1

	if prev_boss_health_bar != $Boss.get_health_remaining():
		is_sucking = true;
		var players = player_container.get_all_players();
		for player in players:
			if player.state == player.states.SUCKING:
				$Camera2D.start_shake(0.1, suck_current_intensity)
				break;
	else:
		is_sucking = false;
	prev_boss_health_bar = $Boss.get_health_remaining()


func _on_boss_died():
		round_ended.emit(true)


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
	var tweezer_count = 1
	if PlayerInputDevices.get_all_players().size() > 2:
		tweezer_count = 2

	for _ii in range(tweezer_count):
		var tweezers = preload("res://tweezers/tweezers.tscn").instantiate()
		
		for jj in range(10):
			tweezers.target_node = player_container.choose_random_player()
			if tweezers.target_node.state != tweezers.target_node.states.TWEEZED:
				break
	
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
	const secs_until_max_spawn_rate = 30

	var new_wait_time = max(
		min_spawn_rate,
		max_spawn_rate - (max_spawn_rate - min_spawn_rate) * (float(stage_duration) / secs_until_max_spawn_rate)
	)
	$TweezerSpawnTimer.wait_time = new_wait_time


func _on_round_timer_timeout() -> void:
	round_duration += 1
	stage_duration += 1


func _on_boss_health_stage_depleted() -> void:
	# reset spawn timing
	stage_duration = 0
	
	for player in player_container.get_all_players():
		# this gives them speed again
		if player.state == player.states.TWEEZED:
			# don't need to force roll
			continue
		var away_from_boss = player.global_position - $Boss.global_position
		player.push(away_from_boss)

		
	$BarrierSpawner.spawn_barriers(6)
	boss_audio.randomise_sound()
	boss_audio.play()
	var dead_players = PlayerInputDevices.get_all_players().filter(
		func(x): return (
			(
				player_container.get_player_by_id(x) != null
				and player_container.get_player_by_id(x).state == Player.states.TWEEZED
			)
			or x not in player_container.get_all_players().map(
				func(y): return y.player_id
			)
		)
	)
	$PlayerSpawner.spawn_players(dead_players)
	
	for child in get_children():
		if is_instance_of(child, Tweezers):
			child.queue_free()
