extends Node2D


signal died


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


func get_current_health_bar_stage() -> ProgressBar:
	if len(health_bar_stages_remaining) == 0:
		return null
	return health_bar_stages_remaining[0]


func next_health_bar_stage() -> void:
	health_bar_stages_remaining.pop_front()


func _process(delta: float) -> void:
	if get_current_health_bar_stage() == null:
		died.emit()
	
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


func decrease_health(delta: float):
	var health_bar_stage = get_current_health_bar_stage()
	health_bar_stage.value -= 2 * delta
	
	if health_bar_stage.value <= 0:
		_on_health_bar_stage_end()


func _on_health_bar_stage_end():
	next_health_bar_stage()
