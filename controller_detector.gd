class_name ControllerDetector extends Node


func _input(event: InputEvent) -> void:
	print(event.device)
	print(event.as_text())
	
	if not event.device in Global.devices_detected:
		Global.devices_detected.append(event.device)

	print(Global.devices_detected)
