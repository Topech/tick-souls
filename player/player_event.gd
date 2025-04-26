class_name PlayerEvent extends Node

## Enabled events will trigger.
@export var enabled: bool = true

## Triggered events have detect that they have been triggered since event was last handled.
var triggered: bool = false


func trigger():
	triggered = true


func clear():
	triggered = false
