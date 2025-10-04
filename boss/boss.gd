extends Node2D


signal died
signal health_stage_depleted


@onready var player_sucking_box = $PlayerSuckingBox

@onready var health_bar_stage_1 = $HealthBar/HealthBarStage1
@onready var health_bar_stage_2 = $HealthBar/HealthBarStage2
@onready var health_bar_stage_3 = $HealthBar/HealthBarStage3
@onready var health_bar_stage_4 = $HealthBar/HealthBarStage4


@onready var health_bar_stages_remaining = [
	health_bar_stage_4,
	health_bar_stage_3,
	health_bar_stage_2,
	health_bar_stage_1,
]


func _ready() -> void:
	var player_count = PlayerInputDevices.get_all_players().size()
	var new_health = 15 + 10 * player_count
	for bar in health_bar_stages_remaining:
		bar.max_value = new_health
		bar.value = new_health


func get_current_health_bar_stage() -> ProgressBar:
	if len(health_bar_stages_remaining) == 0:
		return null
	return health_bar_stages_remaining[0]


func next_health_bar_stage() -> void:
	health_bar_stages_remaining.pop_front()


func get_health_remaining() -> float:
	return (
		health_bar_stage_1.value
		+ health_bar_stage_2.value
		+ health_bar_stage_3.value
		+ health_bar_stage_4.value
	)


func _process(delta: float) -> void:
	if get_current_health_bar_stage() == null:
		died.emit()
	
	var anybody_sucking = false
	
	for body in player_sucking_box.get_overlapping_bodies():
		# debugging purposes
		if body == $PlayerCollisionBox:
			continue
		
		var player: Player = null
		if is_instance_of(body, Player):
			player = body
		elif is_instance_of(body.owner, Player):
			player = body.get_player_node()
		else:
			continue

		if player.state == player.states.SUCKING:
			decrease_health(delta)
			anybody_sucking = true
	
	if anybody_sucking:
		$Sprite2D.frame = 1
	else:
		$Sprite2D.frame = 0


func decrease_health(delta: float):
	var health_bar_stage = get_current_health_bar_stage()
	health_bar_stage.value -= 2 * delta
	
	if health_bar_stage.value <= 0:
		_on_health_bar_stage_depletion()


func _on_health_bar_stage_depletion():
	next_health_bar_stage()
	health_stage_depleted.emit()
