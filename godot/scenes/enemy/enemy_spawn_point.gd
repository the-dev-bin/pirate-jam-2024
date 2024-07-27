class_name EnemySpawnPoint
extends Node2D

var enemy: Enemy
@export var enemy_scene: PackedScene

@onready var enemy_node: EnemyNode = $Enemy
@onready var button: Button = $Button
@onready var selected_crosshair = %SelectedCrosshair

signal pressed
func _ready() -> void:
	button.pressed.connect(_on_button_pressed)
	button.visible = false
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
	button.visible = true


func _on_button_pressed():
	pressed.emit()

func set_selected_crosshair(value: bool) -> void:
	selected_crosshair.visible = value