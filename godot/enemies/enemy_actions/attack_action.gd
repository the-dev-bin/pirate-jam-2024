extends EnemyAction

@export var damage: int

func process_action(player: Node, _enemies: Array[Node], params: Dictionary) -> void:
	if player:
		if params.has('damage'):
			player.damage(params['damage'])
		else:
			printerr('params missing damage value')
	pass