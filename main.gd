extends Node2D

var tweezers_to_free = []


func _process(delta: float) -> void:
	if not tweezers_to_free.is_empty():
		for tweezer in tweezers_to_free:
			tweezer.free()
		tweezers_to_free = []


func _on_tweezers_tweezed_player(player: Player) -> void:
	player.tweeze()


func _on_tweezers_failed(tweezer: Tweezers) -> void:
	tweezers_to_free.append(tweezer)


func _on_timer_timeout() -> void:
	var tweezers = preload("res://tweezers/tweezers.tscn").instantiate()
	tweezers.target_node = $Player
	add_child(tweezers)
	tweezers.failed.connect(_on_tweezers_failed)
