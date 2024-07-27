class_name DefendAction
extends IngredientAction

@export var defense_value:int = 2


func process_action(_player: Node, _enemies: Array[EnemyNode], _targeted_enemy: int) -> void:
	print('add ' + str(defense_value) + ' defense')
	State.player_stats.add_defense(defense_value)


func _to_string() -> String:
	return "Defend against " + str(defense_value) + " damage"
