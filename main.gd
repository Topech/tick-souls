extends Node


@onready var main_menu = $MainMenu
var round: Node
var round_leaderboard: Node


func _on_main_menu_start_game() -> void:
	round = preload("res://root_scenes/round/round.tscn").instantiate()
	round.round_ended.connect(_on_round_end)
	add_child(round)
	remove_child(main_menu)
	main_menu = null


func _on_round_end() -> void:
	round_leaderboard = preload("res://root_scenes/round/round_leaderboard.tscn").instantiate()
	add_child(round_leaderboard)
	remove_child(round)
	round = null
