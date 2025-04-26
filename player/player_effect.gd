class_name PlayerEffect extends Node
## A simple base class to handle effects.
## Designed to expose a syncronous API to simplify delegation.


## Only operate effect if enabled = true
@export var enabled: bool = true
#	set(value: bool): ...

## True if effect meets criteria to run.
var triggered: bool = false


## runs every tick if effect is enabled and triggered.
func apply(delta: float):
	assert(false, "Override this base fn...")



func trigger() -> void:
	triggered = true
	# ...

func cancel() -> void:
	triggered = false


func _process(delta: float) -> void:
	if (enabled and triggered):
		apply(delta)
