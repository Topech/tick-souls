extends AudioStreamPlayer

@export_dir var audio_dir: String = "res://assets"  # directory where sounds are stored
var resources: Array[AudioStream] = []

func _ready() -> void:
	load_resources_from_dir(audio_dir)

func load_resources_from_dir(path: String) -> void:
	var dir := DirAccess.open(path)
	if dir == null:
		push_error("Cannot open directory: " + path)
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir():
			if file_name.to_lower().ends_with(".mp3") or file_name.to_lower().ends_with(".mp4") or file_name.to_lower().ends_with(".wav") or file_name.to_lower().ends_with(".ogg"):
				var file_path = path.path_join(file_name)
				var audio_stream = load(file_path)
				if audio_stream is AudioStream:
					resources.append(audio_stream)
		file_name = dir.get_next()
	dir.list_dir_end()

func randomise_sound() -> void:
	if resources.is_empty():
		push_error("no sounds to choose!")
		return
	stream = resources[randi() % resources.size()]
