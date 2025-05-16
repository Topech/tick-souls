extends Node




func _on_main_menu_start_game() -> void:
	var round = preload("res://root_scenes/round/round.tscn").instantiate()
	add_child(round)
	var main_menu = $MainMenu
	remove_child(main_menu)
	
