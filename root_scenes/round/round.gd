extends Node2D

signal round_ended

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
	tweezers.target_node = player_container.choose_random_player()
	add_child(tweezers)
	tweezers.failed.connect(_on_tweezers_failed)
	$TweezerSpawnTimer.wait_time = 10


func _process(_delta: float) -> void:
	if len(player_container.get_all_players()) == 0:
		round_ended.emit()
