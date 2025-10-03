extends Node

@onready var barrier_container = $BarrierContainer

@onready var player_spawn_location = {
	Global.players.PLAYER_1: %PlayerSpawn1,
	Global.players.PLAYER_2: %PlayerSpawn2,
	Global.players.PLAYER_3: %PlayerSpawn3,
	Global.players.PLAYER_4: %PlayerSpawn4,
}


const barrier_count: int = 10;
const SPAWN_ATTEMPTS := 50 # safety so it doesn't loop forever
const MIN_DISTANCE := 64   # how far away barriers must be from each other and players


func _ready() -> void:
	var player_positions : Array[Vector2] = [];
	var barrier_positions : Array[Vector2] = [];
	
	for player_id in PlayerInputDevices.get_all_players():
		player_positions.append(player_spawn_location[player_id].global_position);
	
	for b in barrier_count:
		var barrier = preload("res://barrier/barrier.tscn").instantiate()
		var pos = find_valid_position(barrier_positions)
		if (pos == Vector2.ZERO): continue
		barrier_container.add_child(barrier)
		barrier.global_position = pos
		

func find_valid_position(existing_positions: Array[Vector2]) -> Vector2:
	for attempt in range(SPAWN_ATTEMPTS):
		var random_pos = get_random_position_in_area()
		if is_position_valid(random_pos, existing_positions):
			return random_pos
	return Vector2.ZERO

func is_position_valid(pos: Vector2, existing_positions: Array[Vector2]) -> bool:
	for p in existing_positions:
		if pos.distance_to(p) < MIN_DISTANCE:
			return false
	return true

func get_random_position_in_area() -> Vector2:
	var rect = get_viewport().get_visible_rect()
	return Vector2(
		randf_range(rect.position.x, rect.position.x + rect.size.x),
		randf_range(rect.position.y, rect.position.y + rect.size.y)
	)
