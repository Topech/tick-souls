class_name PlayerMetrics extends Resource


var health: int
var speed: int
var blood: float
var base_speed: float


func _init(health_: int = 100, base_speed_: int = 100) -> void:
	self.health = health_
	self.base_speed = base_speed_
	speed = round(base_speed_) # cant remember why speed is int
	blood = 0
	
