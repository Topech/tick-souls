extends Node

@export_category("Affected Nodes")
@export var node_to_move: CharacterBody2D

@export_category("Parameters")
@export var speed: int
@export var direction: Vector2


func move_node(delta: float) -> void:
	node_to_move.velocity = speed * direction
	node_to_move.move_and_slide()
