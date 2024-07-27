class_name Stats
extends Resource

@export var max_health: int
var current_health: int
@export var defense: int = 0
var conditions: Array[String] # might not use yet

signal health_changed
signal defense_changed

func _init() -> void:
	current_health = max_health

func take_damage(value: int) -> void:
	if defense < value:
		value -= defense
		defense -= value
		current_health -= value
		current_health = clamp(current_health, 0 , max_health)
		defense = clamp(defense, 0, INF)
		health_changed.emit(current_health)
		defense_changed.emit(defense)
	else:
		defense -= value
		defense = clamp(defense, 0, INF)
		defense_changed.emit(defense)

func add_defense(value: int) -> void:
	defense += value
	defense = clamp(defense, 0, INF)