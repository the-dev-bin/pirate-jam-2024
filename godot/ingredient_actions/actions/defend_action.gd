extends IngredientAction

@export var defend:int = 2


func process_action(_player: Node, _enemies: Array[Node], _targeted_enemy: int) -> void:
	print('add ' + str(defend) + ' defense')
