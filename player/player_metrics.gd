extends Node

class PlayerMetrics:
	var health: int
	var speed: int
	
	func _init(health_override: int = 100, speed_override: int = 100) -> void:
		health = health_override
		speed = speed_override
		
