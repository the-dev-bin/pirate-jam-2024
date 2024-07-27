class_name AttackAction
extends IngredientAction

@export var attack_range: Array[int] = [1,2]
@export var target: IngredientAction.TARGET



func process_action(_player: Node, enemies: Array[Node], targeted_enemy: int) -> void:
	var enemy: Node = enemies[targeted_enemy]
	if enemy is EnemyNode:
		var enemy_node: EnemyNode = enemy
		var enemy_resource: Enemy = enemy_node.enemy
		print('attacking for ' + str(attack_range[0]) + ' damage')
		print('enemy health before: ' + str(enemy_resource.stats.current_health))
		enemy_resource.stats.current_health -= attack_range[0]

		enemy_node.current_health_label.text = str(enemy_resource.stats.current_health)
		enemy_node.max_health_label.text = str(enemy_resource.stats.max_health)
		var tween: Tween = enemy_node.create_tween()
		tween.tween_property(enemy_node.health_bar, "value", enemy_resource.stats.current_health, 0.5)

		print('enemy health after: ' + str(enemy_resource.stats.current_health))

func _to_string() -> String:
	return "Deal " + str(attack_range[0]) + "-" + str(attack_range[1]) + " damage"
