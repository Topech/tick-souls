extends Node


@onready var main_menu = $MainMenu
var round_: Node
var boss_round: Node
var round_leaderboard: Node
var win_board: Node


func _on_main_menu_start_game() -> void:
	round_ = preload("res://root_scenes/round/round.tscn").instantiate()
	round_.round_ended.connect(_on_round_end)
	add_child(round_)
	remove_child(main_menu)
	main_menu = null


func _on_main_menu_start_boss() -> void:
	boss_round = preload("res://root_scenes/boss_round/boss_round.tscn").instantiate()
	boss_round.round_ended.connect(_on_boss_end)
	add_child(boss_round)
	if main_menu != null:
		remove_child(main_menu)
		main_menu = null
	elif round_leaderboard != null:
		remove_child(round_leaderboard)
		round_leaderboard = null


func _on_leaderboard_continue() -> void:
	round_ = preload("res://root_scenes/round/round.tscn").instantiate()
	round_.round_ended.connect(_on_round_end)
	add_child(round_)
	remove_child(round_leaderboard)
	round_leaderboard = null


func _on_round_end(round_duration: int) -> void:
	round_leaderboard = preload("res://root_scenes/round/round_leaderboard.tscn").instantiate()
	round_leaderboard.round_duration = round_duration
	round_leaderboard.continue_pressed.connect(_on_leaderboard_continue)
	add_child(round_leaderboard)
	remove_child(round_)
	round_ = null


func _on_boss_end(did_win: bool) -> void:
	win_board = preload("res://root_scenes/win.tscn").instantiate()
	win_board.did_win = did_win
	add_child(win_board)
	remove_child(boss_round)
	boss_round = null
	
