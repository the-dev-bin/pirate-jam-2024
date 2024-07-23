extends Node2D

var enemy: Enemy

func _ready() -> void:
	$Enemy.queue_free()

func get_enemy() -> Enemy:
	return enemy

func add_enemy(_enemy: Enemy) -> void:
	enemy = enemy