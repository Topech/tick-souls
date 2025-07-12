class_name PlayerDevice extends RefCounted

const INVALID_DEVICE = 120


var player_id: Global.players
var device_id: int
var is_keyboard: bool
var _is_invalid: bool = false


func _init(player_id: Global.players, device_id: int) -> void:
	self.player_id = player_id
	self.device_id = device_id
	self.is_keyboard = false


static func create_keyboard_device(player_id: Global.players) -> PlayerDevice:
	const KEYBOARD_DEVICE_ID: int = 0
	var instance = PlayerDevice.new(player_id, KEYBOARD_DEVICE_ID)
	instance.is_keyboard = true
	return instance


static func create_invalid(player_id: Global.players) -> PlayerDevice:
	var invalid_instance = PlayerDevice.new(player_id, INVALID_DEVICE)
	invalid_instance._is_invalid = true
	return invalid_instance


func is_invalid():
	return self._is_invalid or device_id == INVALID_DEVICE


func check_owns_input(event: InputEvent):
	if not is_keyboard and event is InputEventJoypadButton:
		return event.device == device_id
	
	elif is_keyboard and event is InputEventKey:
		return true
	
	return false
	
