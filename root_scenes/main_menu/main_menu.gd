extends Control

signal start_game


func _on_button_pressed() -> void:
	if len(PlayerInputDevices.get_all_players()) > 0:
		start_game.emit()
