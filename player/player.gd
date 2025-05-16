class_name Player extends Node2D


# contoller support
@export var player_id := Global.players.NO_PLAYER
@onready var device_id: int = PlayerInputDevices.get_players_device(player_id)

# data structures
@onready var metrics = PlayerMetrics.new()

# control nodes
@onready var walk_event = $WalkEvent
@onready var roll_event = $RollEvent
@onready var suck_event = $SuckEvent
@onready var tweeze_event = $TweezeEvent

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
	
	if tweeze_event.triggered:
		walk_effect.enabled = false
		roll_effect.enabled = false
		suck_effect.enabled = false
		return
	
	# process inputs
	if (walk_event.triggered and not suck_effect.activated):
		walk_effect.activate()
	else:
		walk_effect.deactivate()

	if (
		roll_event.triggered
		and not roll_effect.activated
		and not suck_effect.activated
	):
		roll_effect.activate()

	if (
		suck_event.triggered
		and not roll_effect.activated
	):
		suck_effect.activate()
	# todo: i don't think 'not triggered' is adequate state.
	elif not suck_event.triggered:
		suck_effect.deactivate()

	if suck_effect.activated:
		const BLOOD_PER_SEC = 10
		metrics.blood += BLOOD_PER_SEC * delta

	# update UI
	blood_bar.value = metrics.blood


func tweeze():
	tweeze_event.trigger()
