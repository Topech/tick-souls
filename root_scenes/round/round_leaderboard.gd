extends Control


signal continue_pressed


## in secs
@export var round_duration: int


@onready var round_duration_label = $RoundDurationLabel/RoundDurationValue


func _ready() -> void:
	round_duration_label.text = str(round_duration) + " sec"


func _on_continue_button_pressed() -> void:
	continue_pressed.emit()
