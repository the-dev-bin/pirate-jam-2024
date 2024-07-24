class_name EnemySpawnPoint
extends Node2D

var enemy: Enemy
@export var enemy_scene: PackedScene
@onready var enemy_node: EnemyNode = $Enemy

func _ready() -> void:
	remove_enemy()

func get_enemy() -> Enemy:
	return enemy

func get_enemy_node() -> EnemyNode:
	return enemy_node

func set_enemy(_enemy: Enemy) -> void:
	enemy = enemy

func remove_enemy() -> void:
	enemy_node.queue_free()
	enemy = null

func spawn_enemy(_enemy: Enemy) -> void:
	enemy = _enemy
	enemy_node = enemy_scene.instantiate()
	add_child(enemy_node)
	enemy_node.setup(enemy)

