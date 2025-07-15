class_name Player extends Node2D


# contoller support
@export var player_id := Global.players.NO_PLAYER
@onready var player_device: PlayerDevice = PlayerInputDevices.get_players_device(player_id)

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
	roll_effect.roll_speed = 3 * metrics.speed

	if tweeze_event.triggered:
			walk_effect.enabled = false
			roll_effect.enabled = false
			suck_effect.enabled = false
			return

	# process inputs
	if (walk_event.triggered and not suck_effect.is_activated):
			walk_effect.activate()
	else:
			walk_effect.deactivate()

	if (
			roll_event.triggered
			and not roll_effect.is_activated
			and not suck_effect.is_activated
	):
			roll_effect.activate()
			await roll_effect.deactivated
			roll_event.clear()

	if (
			suck_event.triggered
			and not roll_effect.is_activated
	):
			suck_effect.activate()
	# todo: i don't think 'not triggered' is adequate state.
	elif not suck_event.triggered:
			suck_effect.deactivate()

	if suck_effect.is_activated:
			const BLOOD_PER_SEC = 10
			metrics.blood += BLOOD_PER_SEC * delta
			metrics.speed = 100 - 50 * (metrics.blood / 100)
			roll_effect.roll_cooldown_duration = 1.1 + 0.2 * (metrics.blood / 100)

	# update UI
	blood_bar.value = metrics.blood


func tweeze():
	tweeze_event.trigger()
