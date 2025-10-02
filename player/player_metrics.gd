class_name PlayerMetrics extends Resource


var health: int
var speed: int
var blood: float
var base_speed: float


func _init(health: int = 100, base_speed: int = 100) -> void:
	self.health = health
	self.base_speed = base_speed
	speed = base_speed
	blood = 0
	
