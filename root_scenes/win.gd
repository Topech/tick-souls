extends Node2D

@export var did_win: bool = true


func _ready() -> void:
	if did_win:
		$Label.text = "You Win!"
	else:
		$Label.text = "You Lose."
