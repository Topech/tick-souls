extends AudioStreamPlayer


@export var resources: Array[AudioStream] = []


func randomise_sound():
	if len(resources) == 0:
		push_error('no sounds to choose!')
	stream = resources[
		round(randf() * (len(resources) - 1) )
	]


func _ready() -> void:
	randomise_sound()
