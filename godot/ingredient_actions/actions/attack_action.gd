class_name AttackAction
extends IngredientAction

@export var attack_range: Array[int] = [1,2]
@export var target: IngredientAction.TARGET



func process_action(_player: Node, _enemies: Array[Node], _targeted_enemy: int) -> void:
	print('deal ' + str(attack_range[0]) + ' damage')

func _to_string() -> String:
	return "Deal " + str(attack_range[0]) + "-" + str(attack_range[1]) + " damage"
