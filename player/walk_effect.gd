extends PlayerEffect

@export_group("Target Nodes")
@export var target_move_node: CharacterBody2D

@export_group("Parameters")
@export var direction: Vector2
@export var speed: int = 100


func apply(delta: float):
	target_move_node.velocity = direction.normalized() * speed
	target_move_node.move_and_slide()
