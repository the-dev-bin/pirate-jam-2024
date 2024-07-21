extends IngredientAction

@export var attack_range: Array[int] = [1,2]
@export var target: IngredientAction.TARGET



func process_action(_player: Node, _enemies: Array[Node], _targeted_enemy: int):
	print('add ' + str(attack_range[0]) + ' defense')
