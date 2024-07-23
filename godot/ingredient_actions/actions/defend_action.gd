class_name DefendAction
extends IngredientAction

@export var defense_value:int = 2


func process_action(_player: Node, _enemies: Array[Node], _targeted_enemy: int) -> void:
	print('add ' + str(defense_value) + ' defense')


func _to_string() -> String:
	return "Defend against " + str(defense_value) + " damage"
