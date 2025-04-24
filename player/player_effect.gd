class_name PlayerEffect extends Node
## A simple base class to handle effects.
## Designed to work by polling


## Only operate effect if enabled = true
@export var enabled: bool = true
#	set(value: bool): ...

var triggered: bool = false


func trigger() -> void:
	triggered = true
	# ...

func cancel() -> void:
	triggered = false


func apply(delta: float):
	assert(false, "Override this base fn...")
