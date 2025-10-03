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
	states.ROLLING: [states.IDLE, states.WALKING, states.SUCKING],
	states.TWEEZED: SpecialStateTransistions.NONE,
}


const TICK_SIZE_MIN_SCALE: Vector2 = Vector2(0.3, 0.3);
const TICK_SIZE_MAX_SCALE: Vector2 = Vector2(1.0, 1.0);


func validate_state_machine(states_: Dictionary, transitions_: Dictionary) -> Error:
	var all_states = states_.values()
	var all_states_with_transitions = transitions_.keys()

	# check transition has all states
	for state_ in all_states:
		if not all_states_with_transitions.has(state_):
			return ERR_INVALID_DATA

	# check states has all transition states
	for state_ in all_states_with_transitions:
		if not all_states.has(state_):
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


@export var suck_strategy_type = Global.SuckStrategyType.STANDARD
@onready var suck_ray = $SuckRay

# contoller support
@export var player_id := Global.players.NO_PLAYER
@onready var player_device: PlayerDevice = PlayerInputDevices.get_players_device(player_id)

# data structures
@onready var state = states.IDLE
@onready var metrics = PlayerMetrics.new()
@onready var player_details: Global.PlayerDetails = Global.player_details_lookup[player_id]
var suck_strategy: PlayerSuckStrategy

# control nodes
@onready var walk_event = $WalkEvent
@onready var roll_event = $RollEvent
@onready var suck_event = $SuckEvent
@onready var tweeze_event = $TweezeEvent

@onready var roll_effect = $RollEffect
@onready var walk_effect = $WalkEffect
@onready var suck_effect = $SuckEffect

# audio nodes
@onready var suck_audio = $SuckAudio
@onready var squeeze_audio = $SqueezeAudio
@onready var roll_audio = $RollAudio
@onready var tweeze_scream_audio = $TweezeScreamAudio

# ui nodes
@onready var blood_bar = $BloodProgressBar
@onready var roll_cooldown_bar = $RollCooldownBar

# collision and sprite nodes
@onready var visual_body: StaticBody2D = $VisualBody2d


func _ready() -> void:
	if validate_state_machine(states, transitions) != OK:
		push_error("state machine is invalid")

	if suck_strategy_type == Global.SuckStrategyType.STANDARD:
		suck_strategy = PlayerSuckStrategyStandard.new(metrics)
	elif suck_strategy_type == Global.SuckStrategyType.BOSS:
		suck_strategy = PlayerSuckStrategyBoss.new(metrics, suck_ray)
	else:
		push_error("invalid suck_strategy_type")

	visual_body.modulate = player_details.tinge


func _process(delta: float) -> void:
	# ! DEBUG ONLY
	if (Input.is_key_pressed(KEY_P)):
		queue_free()
	
	# sync nodes
	walk_effect.speed = metrics.speed
	walk_effect.direction = walk_event.direction
	roll_effect.roll_direction = walk_event.direction
	roll_effect.roll_speed = 1.5 * metrics.base_speed + 2 * metrics.blood
	roll_effect.roll_cooldown_duration = 1.0 + 1.0 * (metrics.blood / 100)


	var old_state: states = state

	# determine next state
	if tweeze_event.triggered:
		state = transition(state, states.TWEEZED)
		# Note: tweeze_event always ends in player free
	if roll_effect.is_activated:
		# pause all state changes if rolling
		pass
	elif suck_event.triggered:
		state = transition(state, states.SUCKING)
		# Note: suck_event clears itself
	elif roll_event.triggered:
		# handles cooldown
		if not roll_effect.is_activated:
			state = transition(state, states.ROLLING)
		roll_event.clear()
	elif walk_event.triggered:
		state = transition(state, states.WALKING)
		# Note: walk_event clears itself
	else:
		state = transition(state, states.IDLE)

	# detect when leaving a state
	if old_state != state:
		match old_state:
			states.SUCKING:
				suck_effect.deactivate()
				suck_audio.stop()

	# activate state effects
	match state:
		states.TWEEZED:
			walk_effect.enabled = false
			roll_effect.enabled = false
			suck_effect.enabled = false
			
			if old_state != states.TWEEZED:
				play_tweezed_audio()

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
			
			# note: must check is_activated again,
			# not guaranteed on calling activate
			if roll_effect.is_activated and old_state != states.ROLLING:
				roll_audio.randomise_sound()
				roll_audio.play()

		states.SUCKING:
			suck_effect.enabled = true
			if not suck_effect.is_activated:
				suck_effect.activate()
			walk_effect.enabled = false
			roll_effect.enabled = false

			if old_state != states.SUCKING:
				suck_audio.randomise_sound()
				suck_audio.play()
			
			suck_strategy.suck(delta)

		states.IDLE, _:
			walk_effect.enabled = false
			roll_effect.enabled = false
			suck_effect.enabled = false

	# update UI
	blood_bar.value = metrics.blood
	update_tick_size()
	
	roll_cooldown_bar.value = (
		100 - (
			roll_effect.roll_cooldown_timer.time_left \
		 	/ roll_effect.roll_cooldown_timer.wait_time * 100
		)
	)


func tweeze():
	tweeze_event.trigger()
	
func play_tweezed_audio():
	squeeze_audio.randomise_sound()
	squeeze_audio.play()
	tweeze_scream_audio.randomise_sound()
	tweeze_scream_audio.play()

func update_tick_size():
	var blood_ratio = metrics.blood / 100.0  # assuming blood is 0-100
	var new_scale = TICK_SIZE_MIN_SCALE.lerp(TICK_SIZE_MAX_SCALE, blood_ratio)
	visual_body.scale = new_scale
	
