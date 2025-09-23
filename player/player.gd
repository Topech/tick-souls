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
	elif is_instance_of(transitions[current], TYPE_ARRAY):
		if next in transitions[current]:
			return OK
		else:
			return FAILED
	elif transitions[current] == SpecialStateTransistions.NONE:
		return FAILED
	elif transitions[current] == SpecialStateTransistions.INVALID:
		return FAILED
	elif transitions[current] == SpecialStateTransistions.ANY:
		return OK
	return FAILED


func transition(current: states, next: states) -> states:
	if check_state_transition(current, next) != OK:
		return current
	return next


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


func _ready() -> void:
	if validate_state_machine(states, transitions) != OK:
		push_error("state machine is invalid")


func _process(delta: float) -> void:
	# ! DEBUG ONLY
	if (Input.is_key_pressed(KEY_P)):
		queue_free()
	
	# sync nodes
	walk_effect.speed = metrics.speed
	walk_effect.direction = walk_event.direction
	roll_effect.roll_direction = walk_event.direction
	roll_effect.roll_speed = 3 * metrics.speed

	var old_state = state

	# determine next state
	if tweeze_event.triggered:
		state = transition(state, states.TWEEZED)
	if roll_effect.is_activated:
		pass
	elif suck_event.triggered:
		state = transition(state, states.SUCKING)
		suck_event.clear()
	elif roll_event.triggered:
		# handles cooldown
		if not roll_effect.is_activated:
			state = transition(state, states.ROLLING)
		roll_event.clear()
	elif walk_event.triggered:
		state = transition(state, states.WALKING)
	else:
		state = transition(state, states.IDLE)
		
	# activate state effects
	match state:
		states.TWEEZED:
			walk_effect.enabled = false
			roll_effect.enabled = false
			suck_effect.enabled = false

		states.WALKING:
			walk_effect.enabled = true
			if not walk_effect.is_activated:
				walk_effect.activate()
			roll_effect.enabled = false
			suck_effect.enabled = false

		states.ROLLING:
			roll_effect.enabled = true
			if not roll_effect.is_activated:
				roll_effect.activate()
			suck_effect.enabled = false
			walk_effect.enabled = false
			# Don't do anything while rolling
			# Note: needs to check bc activate isn't guaranteed
			if roll_effect.is_activated:
				await roll_effect.roll_finished
				roll_effect.deactivate()

		states.SUCKING:
			suck_effect.enabled = true
			if not suck_effect.is_activated:
				suck_effect.activate()
			walk_effect.enabled = false
			roll_effect.enabled = false
			const BLOOD_PER_SEC = 10
			metrics.blood += BLOOD_PER_SEC * delta
			metrics.speed = 100 - 50 * (metrics.blood / 100)
			roll_effect.roll_cooldown_duration = 1.1 + 0.2 * (metrics.blood / 100)

		states.IDLE, _:
			walk_effect.enabled = false
			roll_effect.enabled = false
			suck_effect.enabled = false

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
