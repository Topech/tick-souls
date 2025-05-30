class_name PlayerDevice extends RefCounted

const INVALID_DEVICE = 120


var player_id: Global.players
var device_id: int
var _is_invalid: bool = false


func _init(player_id: Global.players, device_id: int) -> void:
	self.player_id = player_id
	self.device_id = device_id


static func create_invalid(player_id: Global.players) -> PlayerDevice:
	var invalid_instance = PlayerDevice.new(player_id, INVALID_DEVICE)
	invalid_instance._is_invalid = true
	return invalid_instance


func is_invalid():
	return self._is_invalid or device_id == INVALID_DEVICE


func check_owns_input(event: InputEvent):
	return event.device == device_id
	
