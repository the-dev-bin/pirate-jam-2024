class_name EnemyNode
extends Node2D

@onready var enemy_sprite: Sprite2D = %EnemySprite
@onready var intent_icon: Sprite2D = %IntentIcon

var enemy: Enemy

func _ready() -> void:
	intent_icon.visible = false

func setup(_enemy: Enemy) -> void:
	enemy = _enemy
	enemy_sprite.texture = ResourceLoader.load(enemy.sprite)

