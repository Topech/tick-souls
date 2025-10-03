class_name Tweezers extends CharacterBody2D

@export_group("Target Nodes")
@export var target_node: Node2D
@export var tweeze_secs: int = 10


@onready var shadow = $Shadow
@onready var tweezer_visuals = $TweezerVisuals
@onready var tweeze_audio = $TweezeAudio


signal tweezed_player
signal failed


enum tweezer_states {
	SHADOW_ONLY,
	FOLLOWING,
	TELEGRAPH,
	PRE_TWEEZE,
	TWEEZING,
	FAILED,
}


var tweezed_player_node: Player = null
var _target_switch_cooldown: bool = false
var _target_switch_cooldown_duration: float = 2.0
var _tweezer_completion: float = 0  # between 0 and 1
var _pre_tweeze_animation_timer = 0;
var _pre_tweeze_animation_flag = false;

var tweezer_state = tweezer_states.FOLLOWING

const _pre_tweeze_animation_interval: float = 0.1;

func _ready() -> void:
	tweezer_visuals.visible = false


func _process(delta: float) -> void:
	var tweezer_follow_rate: int = 100
	var shadow_shrink_rate: float = 0.1
	var shadow_alpha_rate: float = 0.02

	_tweezer_completion += delta / tweeze_secs

	# state machine
	if tweezer_state == tweezer_states.TWEEZING:
		# tweezer sorted itself
		pass
	elif _tweezer_completion < 0.3:
		tweezer_state = tweezer_states.SHADOW_ONLY
	elif _tweezer_completion < 0.5:
		tweezer_state = tweezer_states.FOLLOWING
	elif _tweezer_completion < 0.7:
		tweezer_state = tweezer_states.TELEGRAPH
	elif _tweezer_completion < 1:
		tweezer_state = tweezer_states.PRE_TWEEZE
	elif _tweezer_completion >= 1:
		tweezer_state = tweezer_states.FAILED

	$Shadow/Sprite2D.modulate.a += shadow_alpha_rate * delta

	#match (tweezer_state):
		#tweezer_states.SHADOW_ONLY or tweezer_states.FOLLOWING:
			#pass
	
	if target_node == null or target_node.is_queued_for_deletion():
		target_node = null
		queue_free()
		# break early
		return

	if (
		tweezer_state == tweezer_states.SHADOW_ONLY
		or tweezer_state == tweezer_states.FOLLOWING
		or tweezer_state == tweezer_states.TELEGRAPH
		or tweezer_state == tweezer_states.PRE_TWEEZE
	):
		velocity = position.direction_to(target_node.position) * tweezer_follow_rate
		move_and_slide()
		
		if not _target_switch_cooldown:
			check_for_new_target_player()
		
		shadow.scale = Vector2(
			shadow.scale.x - shadow_shrink_rate * delta,
			shadow.scale.y - shadow_shrink_rate * delta,
		)
	if tweezer_state == tweezer_states.FOLLOWING:
		$TweezerVisuals.visible = true
	if tweezer_state == tweezer_states.TELEGRAPH:
		_pre_tweeze_animation_timer += delta;
		if _pre_tweeze_animation_timer >= _pre_tweeze_animation_interval:
			_pre_tweeze_animation_flag = !_pre_tweeze_animation_flag;
			_pre_tweeze_animation_timer = 0
		if _pre_tweeze_animation_flag == true:
			tweezer_visuals.frame = 0
		else:
			tweezer_visuals.frame = 1
	if tweezer_state == tweezer_states.PRE_TWEEZE:
		_pre_tweeze_animation_timer += delta;
		if _pre_tweeze_animation_timer >= _pre_tweeze_animation_interval:
			_pre_tweeze_animation_flag = !_pre_tweeze_animation_flag;
			_pre_tweeze_animation_timer = 0
		
		if _pre_tweeze_animation_flag == true:
			tweezer_visuals.frame = 0
		else:
			tweezer_visuals.frame = 3
		check_for_tweezable_player()
	if tweezer_state == tweezer_states.FAILED:
		failed.emit(self)
	# successful tweeze
	if tweezer_state == tweezer_states.TWEEZING:
		velocity = Vector2(0, -500)
		move_and_slide()
		if tweezed_player_node != null:
			tweezed_player_node.position = position
		tweezer_visuals.frame = 3


func tweeze_player(player):
	tweezed_player_node = player
	tweeze_audio.play()
	tweezed_player.emit(player)


func switch_target(player):
	target_node = player
	_target_switch_cooldown = true
	var cooldown_timer = get_tree().create_timer(
		_target_switch_cooldown_duration
	)
	cooldown_timer.timeout.connect(func(): 
		_target_switch_cooldown = false
	)


func check_for_tweezable_player():
	var overlapping_bodies = $TweezePlayerDetector.get_overlapping_bodies()
	for body in overlapping_bodies:
		if is_instance_of(body.owner, Player):
			tweezer_state = tweezer_states.TWEEZING
			var player = body.get_player_node()
			tweeze_player(player)
			break


func check_for_new_target_player():
	var overlapping_bodies = $TargetPlayerDetector.get_overlapping_bodies()
	for body in overlapping_bodies:
		if is_instance_of(body.owner, Player):
			var player = body.get_player_node()
			if player != target_node:
				switch_target(player)
				break
