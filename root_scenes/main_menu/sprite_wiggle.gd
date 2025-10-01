extends Sprite2D


## in degrees
@export var wiggle_angle: int = 5


var rotate_cw = false
var current_timer: SceneTreeTimer = null
var timer_duration = 0.5


func _ready() -> void:
	# I know this is cursed but also its easier than
	# maths
	current_timer = _create_timer()


func _exit_tree() -> void:
	# stops trying to create timers
	current_timer.timeout.disconnect(_on_timer_timeout)


func _create_timer():
	var new_timer = get_tree().create_timer(timer_duration)
	new_timer.timeout.connect(_on_timer_timeout)
	return new_timer


func _on_timer_timeout():
	rotate_cw = !rotate_cw
	current_timer = _create_timer()
	

func _process(_delta: float) -> void:
	var percent_done: float = current_timer.time_left / timer_duration
	
	var new_angle = wiggle_angle * percent_done
	if rotate_cw:
		new_angle *= -1
	rotation = deg_to_rad(new_angle)
	
	
