class_name PlayerEffect extends Node
## A simple base class to handle effects.
## Designed to expose a syncronous API to simplify delegation.


signal activated
signal deactivated


## Only operate effect if enabled = true
@export var enabled: bool = true
#=	set(value: bool): ...

## True if effect meets criteria to run.
var is_activated: bool = false


## runs every tick if effect is enabled and activated.
func apply(delta: float):
	assert(false, "Override this base fn...")


func activate() -> void:
	if enabled:
		is_activated = true
		activated.emit()


func deactivate() -> void:
	is_activated = false
	deactivated.emit()


func _process(delta: float) -> void:
	if (enabled and is_activated):
		apply(delta)
