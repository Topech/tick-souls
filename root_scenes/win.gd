extends Control

signal continue_pressed

@export var did_win: bool = true

func _ready() -> void:
	if did_win:
		$Label.text = "You Win!"
	else:
		$Label.text = "You Lose."
		
func _on_win_continue_button_pressed() -> void:
	continue_pressed.emit()
