class_name Enums


const Actions := preload("res://enums/actions.gd").Actions


static func action_as_str(member: Actions) -> String:
	return Actions.keys()[member].to_lower()
