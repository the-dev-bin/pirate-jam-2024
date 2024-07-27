extends EnemyAction

@export var defense: int

func process_action(player: Node, _enemies: Array[EnemyNode], params: Dictionary, base_enemy: EnemyNode) -> void:
	if params.has('min_value'):
		print('adding defense')
		base_enemy.enemy.stats.add_defense(params['min_value'])
	queue_free()
