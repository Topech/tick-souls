class_name PlayerSuckStrategyStandard extends PlayerSuckStrategy


var _metrics: PlayerMetrics


func _init(metrics: PlayerMetrics):
	_metrics = metrics


func suck(delta: float) -> void:
	const BLOOD_PER_SEC = 10
	_metrics.blood += BLOOD_PER_SEC * delta
	_metrics.speed = 100 - 50 * (_metrics.blood / 100)
