class_name PlayerSuckStrategyBoss extends PlayerSuckStrategy


var _metrics: PlayerMetrics
var _ray: RayCast2D


func _init(metrics: PlayerMetrics, ray: RayCast2D):
	_metrics = metrics
	_ray = ray


func suck(delta: float) -> void:
	if _ray.is_colliding():
		const BLOOD_PER_SEC = 10
		_metrics.blood += BLOOD_PER_SEC * delta
		_metrics.speed = 100 - max(1, 50 * round((_metrics.blood / 100)))
