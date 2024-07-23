class_name EnemyNode
extends Node2D

@onready var enemy_sprite: Sprite2D = %EnemySprite
@onready var intent_icon: Sprite2D = %IntentIcon

var enemy: Enemy
var previous_action: EnemyActionEntry
var planned_action: EnemyActionEntry
var current_intent: String

func _ready() -> void:
	intent_icon.visible = false

func setup(_enemy: Enemy) -> void:
	enemy = _enemy
	enemy_sprite.texture = ResourceLoader.load(enemy.sprite)

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