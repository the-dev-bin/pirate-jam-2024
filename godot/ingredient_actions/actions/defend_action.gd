extends IngredientAction

@export var defend:int = 2


func process_action(player: Node, _enemies: Array[Node], _targetted_enemy: int):
	print('add ' + str(defend) + ' defense')
