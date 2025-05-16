class_name PlayerMetrics extends Node


var health: int
var speed: int
var blood: float

func _init(health_override: int = 100, speed_override: int = 100) -> void:
	health = health_override
	speed = speed_override
	blood = 0
	
