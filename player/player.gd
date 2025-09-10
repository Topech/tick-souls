class_name Player extends Node2D


enum states {
	INVALID = 0,
	IDLE,
	WALKING,
	SUCKING,
	ROLLING,
	TWEEZED,
}

enum SpecialStateTransistions {
	INVALID = 0,
	ANY,
	NONE
}

var transitions = {
	states.INVALID: SpecialStateTransistions.INVALID,
	states.IDLE: SpecialStateTransistions.ANY,
	states.WALKING: SpecialStateTransistions.ANY,
	states.SUCKING: SpecialStateTransistions.ANY,
	states.ROLLING: [states.IDLE, states.WALKING],
	states.TWEEZED: SpecialStateTransistions.NONE,
}


func validate_state_machine(states_: Dictionary, transitions_: Dictionary) -> Error:
	var all_states = states_.values()
	var all_states_with_transitions = transitions.keys()
	
	# check transition has all states
	for state in all_states:
		if not all_states_with_transitions.has(state):
			return ERR_INVALID_DATA
	
	# check states has all transition states
	for state in all_states_with_transitions:
		if not all_states.has(state):
			return ERR_INVALID_DATA
		
	return OK


func check_state_transition(current: states, next: states) -> Error:
	if not transitions.has(current):
		return FAILED
	if transitions[current] == SpecialStateTransistions.NONE:
		return FAILED
	if transitions[current] == SpecialStateTransistions.INVALID:
		return FAILED
	if transitions[current] == SpecialStateTransistions.ANY:
		return OK
	if next in transitions[current]:
		return OK
	return FAILED


# contoller support
@export var player_id := Global.players.NO_PLAYER
@onready var player_device: PlayerDevice = PlayerInputDevices.get_players_device(player_id)

# data structures
@onready var state = states.IDLE
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
@onready var roll_cooldown_bar = $RollCooldownBar


func _process(delta: float) -> void:
	# ! DEBUG ONLY
	if (Input.is_key_pressed(KEY_P)):
		queue_free()
	
	# sync nodes
	walk_effect.speed = metrics.speed
	walk_effect.direction = walk_event.direction
	roll_effect.roll_direction = walk_event.direction
	roll_effect.roll_speed = 3 * metrics.speed

	if tweeze_event.triggered:
		state = states.TWEEZED

	# process inputs
	if (walk_event.triggered and state != states.SUCKING):
			state = states.WALKING
			#walk_effect.activate()
	#else:
			#walk_effect.deactivate()

	if (
			roll_event.triggered
			and state != states.ROLLING
			and state != states.SUCKING
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
	
	roll_cooldown_bar.value = (
		100 - (
			roll_effect.roll_cooldown_timer.time_left \
		 	/ roll_effect.roll_cooldown_timer.wait_time * 100
		)
	)


func tweeze():
	tweeze_event.trigger()
