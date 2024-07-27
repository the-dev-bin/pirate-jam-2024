class_name Player
extends Node2D

@onready var health_bar = %HealthBarContainer

func _ready() -> void:
	print('current health ' + str(State.player_stats.current_health))
	State.player_stats.health_changed.connect(_on_health_changed)
	health_bar.setup(State.player_stats.max_health, State.player_stats.max_health)


func damage(value: int) -> void:
	print('taking damage of' + str(value))
	State.player_stats.take_damage(value)

func _on_health_changed(new_value: int) -> void:
	health_bar.update_value(new_value)