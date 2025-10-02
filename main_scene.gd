extends Node


@onready var main_menu = $MainMenu
var round: Node
var boss_round: Node
var round_leaderboard: Node


func _on_main_menu_start_game() -> void:
	round = preload("res://root_scenes/round/round.tscn").instantiate()
	round.round_ended.connect(_on_round_end)
	add_child(round)
	remove_child(main_menu)
	main_menu = null


func _on_main_menu_start_boss() -> void:
	boss_round = preload("res://root_scenes/boss_round/boss_round.tscn").instantiate()
	add_child(boss_round)
	if main_menu != null:
		remove_child(main_menu)
		main_menu = null
	elif round_leaderboard != null:
		remove_child(round_leaderboard)
		round_leaderboard = null


func _on_leaderboard_continue() -> void:
	round = preload("res://root_scenes/round/round.tscn").instantiate()
	round.round_ended.connect(_on_round_end)
	add_child(round)
	remove_child(round_leaderboard)
	round_leaderboard = null


func _on_round_end(round_duration: int) -> void:
	round_leaderboard = preload("res://root_scenes/round/round_leaderboard.tscn").instantiate()
	round_leaderboard.round_duration = round_duration
	round_leaderboard.continue_pressed.connect(_on_leaderboard_continue)
	add_child(round_leaderboard)
	remove_child(round)
	round = null
	
