extends Node2D

var free_tweezers = false


func _process(delta: float) -> void:
	if free_tweezers:
		$Tweezers.free()
		free_tweezers = false


func _on_tweezers_tweezed_player(player: Player) -> void:
	player.tweeze()


func _on_tweezers_failed() -> void:
	free_tweezers = true
