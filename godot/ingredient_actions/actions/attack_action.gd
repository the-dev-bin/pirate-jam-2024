class_name AttackAction
extends IngredientAction

@export var attack_range: Array[int] = [1,2]
@export var target: IngredientAction.TARGET



func process_action(_player: Node, enemies: Array[Node], targeted_enemy: int) -> void:
	if target == IngredientAction.TARGET.SINGLE:
		var enemy: Node = enemies[targeted_enemy]
		if enemy is EnemyNode:
			var enemy_node: EnemyNode = enemy
			var enemy_resource: Enemy = enemy_node.enemy
			enemy_resource.stats.take_damage(randi_range(attack_range[0], attack_range[1]))

func _to_string() -> String:
	if attack_range[0] == attack_range[1]:
		return "Deal " + str(attack_range[0]) + " danage"
	return "Deal " + str(attack_range[0]) + "-" + str(attack_range[1]) + " damage"
