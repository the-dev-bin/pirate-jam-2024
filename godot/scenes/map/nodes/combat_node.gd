class_name CombatNode
extends Button

@export var spawn_zone: EnemySpawnZone
@export var loot_table: String # update this to be a loot table



func get_params() -> Dictionary:
	return {
		"enemies": spawn_zone.get_encounter().enemies,
		"loot_table": loot_table
	}