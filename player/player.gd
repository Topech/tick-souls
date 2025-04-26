extends Node2D

@onready var metrics = $PlayerMetrics.PlayerMetrics.new()

# control nodes
@onready var walk_event = $WalkEvent
@onready var roll_event = $RollEvent
@onready var suck_event = $SuckEvent

@onready var roll_effect = $RollEffect
@onready var walk_effect = $WalkEffect
@onready var suck_effect = $SuckEffect

# ui nodes
@onready var blood_bar = $BloodProgressBar


func _process(delta: float) -> void:
	# sync nodes
	walk_effect.speed = metrics.speed
	walk_effect.direction = walk_event.direction
	roll_effect.roll_direction = walk_event.direction
	
	# process inputs
	if (walk_event.triggered and not suck_effect.triggered):
		walk_effect.trigger()
	else:
		walk_effect.cancel()

	if (
		roll_event.triggered
		and not roll_effect.triggered
		and not suck_effect.triggered
	):
		roll_effect.trigger()

	if (
		suck_event.triggered
		and not roll_effect.triggered
	):
		suck_effect.trigger()
	# todo: i don't think 'not triggered' is adequate state.
	elif not suck_event.triggered:
		suck_effect.cancel()

	if suck_effect.triggered:
		const BLOOD_PER_SEC = 10
		metrics.blood += BLOOD_PER_SEC * delta

	# update UI
	blood_bar.value = metrics.blood
