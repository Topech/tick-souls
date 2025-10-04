extends Node2D


signal round_ended


@onready var player_container: PlayerContainer = $PlayerSpawner/PlayerContainer


## in secs
var round_duration: int = 0


func _ready() -> void:
	$TweezerSpawnTimer.wait_time = 1 
	$TweezerSpawnTimer.start()
	$TweezerSpawnTimer.wait_time = 10

	var backgrounds = [
		$CrapSkinColor,
		$CrapSkinColor2,
		#$LizardSkinColor,
	]

	var chosen_bg_ii: int = randi_range(0, len(backgrounds) -1)
	for ii in range(len(backgrounds)):
		var background = backgrounds[ii]
		background.visible = bool(ii == chosen_bg_ii)


func _process(delta: float) -> void:
	calc_players_points(delta)
	var players = player_container.get_all_players();
	for player in players:
		if player.state == player.states.SUCKING:
			$Camera2D.start_shake()
			break;

	if len(player_container.get_all_players()) == 0:
		round_ended.emit(round_duration)


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


func _on_timer_timeout() -> void:
	var tweezer_count = 1
	if PlayerInputDevices.get_all_players().size() > 2:
		tweezer_count = 2

	for _ii in range(tweezer_count):
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
	const secs_until_max_spawn_rate = 60.0
	var new_wait_time = max(
		min_spawn_rate,
		max_spawn_rate - (max_spawn_rate - min_spawn_rate) * (float(round_duration) / secs_until_max_spawn_rate)
	)
	$TweezerSpawnTimer.wait_time = new_wait_time


func _on_round_timer_timeout() -> void:
	round_duration += 1


func calc_players_points(delta: float) -> void:
	for player in player_container.get_all_players():
		if player.state == player.states.TWEEZED:
			continue

		var player_id = player.player_id
		var player_details = Global.player_details_lookup[player_id]
		# get points for existing
		player_details.score += delta
		# get points for blood
		player_details.score += player.metrics.blood * delta
