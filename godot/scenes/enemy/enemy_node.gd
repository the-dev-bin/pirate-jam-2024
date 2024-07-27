class_name EnemyNode
extends Node2D

@onready var enemy_sprite: Sprite2D = %EnemySprite
@onready var intent_icon: Sprite2D = %IntentIcon
@onready var health_bar = %HealthBarContainer

var enemy: Enemy
var previous_action: EnemyActionEntry
var planned_action: EnemyActionEntry
var current_intent: String

func _ready() -> void:
	intent_icon.visible = false

func setup(_enemy: Enemy) -> void:
	enemy = _enemy
	enemy.stats.current_health = enemy.stats.max_health
	enemy_sprite.texture = ResourceLoader.load(enemy.sprite)
	enemy.stats.health_changed.connect(_on_health_changed)
	enemy.stats.defense_changed.connect(_on_defense_changed)
	health_bar.setup(enemy.stats.max_health, enemy.stats.max_health)


func get_action() -> EnemyActionEntry:
	print(planned_action)
	var current_action: EnemyActionEntry = planned_action.duplicate()
	previous_action = current_action
	planned_action = null
	return current_action

func update_intent() -> void:
	intent_icon.visible = true
	if previous_action and previous_action.followup:
			var found_action: EnemyActionEntry = enemy.actions.pick_random()
			planned_action = found_action
	else:
		planned_action = enemy.actions.pick_random()
	# eventually set up all the weighted picking, but for now pure random works
	if planned_action.intent == EnemyActionEntry.INTENT.ATTACK:
		intent_icon.modulate = Color.RED
	if planned_action.intent == EnemyActionEntry.INTENT.DEFEND:
		intent_icon.modulate = Color.BLUE
	if planned_action.intent == EnemyActionEntry.INTENT.SUPPORT:
		intent_icon.modulate = Color.PURPLE

func _on_health_changed(new_health: int) -> void:
	health_bar.update_value(new_health)

func _on_defense_changed(new_defense: int) -> void:
	pass