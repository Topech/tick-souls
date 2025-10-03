extends Node


@onready var main_menu = $MainMenu
var round_: Node
var boss_round: Node
var round_leaderboard: Node
var win_board: Node


var rounds_completed = 0


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
	remove_child(main_menu)
	main_menu = null


func _on_leaderboard_continue() -> void:
	if (rounds_completed < 5):
		round_ = preload("res://root_scenes/round/round.tscn").instantiate()
		round_.round_ended.connect(_on_round_end)
		add_child(round_)
	else:
		boss_round = preload("res://root_scenes/boss_round/boss_round.tscn").instantiate()
		boss_round.round_ended.connect(_on_boss_end)
		add_child(boss_round)
	remove_child(round_leaderboard)
	round_leaderboard = null
	
func _on_win_board_continue() -> void:
	main_menu = preload("res://root_scenes/main_menu/main_menu.tscn").instantiate()
	main_menu.start_game.connect(_on_main_menu_start_game)
	main_menu.start_boss.connect(_on_main_menu_start_boss)
	remove_child(win_board)
	win_board = null
	add_child(main_menu)


func _on_round_end(round_duration: int) -> void:
	rounds_completed += 1
	round_leaderboard = preload("res://root_scenes/round/round_leaderboard.tscn").instantiate()
	round_leaderboard.round_duration = round_duration
	round_leaderboard.continue_pressed.connect(_on_leaderboard_continue)
	add_child(round_leaderboard)
	remove_child(round_)
	round_ = null


func _on_boss_end(did_win: bool) -> void:
	win_board = preload("res://root_scenes/win.tscn").instantiate()
	win_board.did_win = did_win
	win_board.continue_pressed.connect(_on_win_board_continue)
	add_child(win_board)
	remove_child(boss_round)
	boss_round = null
	
