class_name Tweezers extends CharacterBody2D

@export_group("Target Nodes")
@export var target_node: Node2D


@onready var shadow = $Shadow
@onready var tweezer_visuals = $TweezerVisuals


signal tweezed_player
signal failed

var tweezed_player_node: Player = null


func _ready() -> void:
	tweezer_visuals.visible = false
	position = target_node.position


func _process(delta: float) -> void:
	if not tweezed_player_node:
		var tweezer_follow_rate: int = 200
		var shadow_shrink_rate: float = 0.1
		var shadow_alpha_rate: float = 0.02

		# still descending
		if shadow.scale.length() > Vector2(0.1, 0.1).length():
			velocity = position.direction_to(target_node.position) * tweezer_follow_rate
			move_and_slide()
			
			shadow.scale = Vector2(
				shadow.scale.x - shadow_shrink_rate * delta,
				shadow.scale.y - shadow_shrink_rate * delta,
			)
			
			if shadow.scale.length() <= Vector2(0.4, 0.4).length():
				$TweezerVisuals.visible = true
				$TweezerVisuals.modulate.a += 0.2 * delta
			
			$Shadow/DebugColorRect.color.a += shadow_alpha_rate * delta
		# finished shadow, end tweeze
		else:
			failed.emit(self)
			#queue_free()
			
		if $TweezerVisuals.visible:
			var overlapping_bodies = $PlayerDetector.get_overlapping_bodies()
			for body in overlapping_bodies:
				# lets just assume you can only have a player scanned by player hurtbox
				var player = body.get_player_node()
				tweezed_player_node = player
				tweezed_player.emit(player)
	# successful tweeze
	else:
		velocity = Vector2(0, -500)
		move_and_slide()
		tweezed_player_node.position = position
		$TweezerVisuals.frame = 1
