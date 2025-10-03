extends Node2D

@onready var player_sucking_box = $PlayerSuckingBox
@onready var health_bar = $HealthBar


func _process(delta: float) -> void:
	for body in player_sucking_box.get_overlapping_bodies():
		# debugging purposes
		if body == $PlayerCollisionBox:
			continue
		
		var player: Player = null
		if is_instance_of(body, Player):
			player = body
		elif is_instance_of(body.owner, Player):
			player = body.get_player_node()
		else:
			continue

		if player.state == player.states.SUCKING:
			health_bar.value -= 2.0 * delta
