class_name PlayerEvent extends Node

## Enabled events will trigger.
@export var enabled: bool = true

## Triggered events have detect that they have been triggered since event was last handled.
var triggered: bool = false

## handle player input device
var player_device: PlayerDevice


func _ready() -> void:
	var player: Player = owner
	player_device = PlayerInputDevices.get_players_device(player.player_id)


func trigger():
	triggered = true


func clear():
	triggered = false
