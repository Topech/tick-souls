extends Node2D


signal round_ended


@onready var player_container = $PlayerSpawner/PlayerContainer


## in secs
var round_duration: int = 0


func _ready() -> void:
	$TweezerSpawnTimer.wait_time = 5
	$TweezerSpawnTimer.start()

	var backgrounds = [
		$CrapSkinColor,
		$CrapSkinColor2,
		$LizardSkinColor,
	]

	var chosen_bg_ii: int = round((len(backgrounds) - 1) * randf())
	for ii in range(len(backgrounds)):
		var background = backgrounds[ii]
		background.visible = bool(ii == chosen_bg_ii)


func _on_tweezers_tweezed_player(player: Player) -> void:
	player.tweeze()

	#var timer = Timer.new()
	var timer = get_tree().create_timer(3.0)
	timer.timeout.connect(func():
		player.queue_free()
	)
	
	var player_round_score = round_duration + player.metrics.blood
	Global.player_details_lookup[player.player_id].score += player_round_score


func _on_tweezers_failed(tweezer: Tweezers) -> void:
	tweezer.queue_free()


func _on_timer_timeout() -> void:
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
	var new_wait_time = max(3, 10 - 7.0 * (float(round_duration) / 120.0))
	$TweezerSpawnTimer.wait_time = new_wait_time


func _process(_delta: float) -> void:
	if len(player_container.get_all_players()) == 0:
		round_ended.emit(round_duration)


func _on_round_timer_timeout() -> void:
	round_duration += 1
