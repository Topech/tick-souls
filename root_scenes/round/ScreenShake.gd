extends Camera2D

@export var shake_intensity: float = 0.2
@export var shake_duration: float = 0.1

var shake_timer: float = 0.0
var base_position: Vector2

func _ready():
	# Remember the position you set in the editor (centered)
	var viewport_size = get_viewport_rect().size
	base_position = viewport_size / 2
	position = base_position

func _process(delta: float) -> void:
	if shake_timer > 0:
		shake_timer -= delta
		position = base_position + Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
	else:
		position = base_position

func start_shake(duration: float = -1.0, intensity: float = -1.0) -> void:
	if duration > 0:
		shake_duration = duration
	if intensity > 0:
		shake_intensity = intensity
	shake_timer = shake_duration
