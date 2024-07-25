class_name Player
extends Node2D

func _ready() -> void:
	print('current health ' + str(State.player_stats.current_health))


func damage(value: int) -> void:
	State.player_stats.current_health -= value
	print('current health ' + str(State.player_stats.current_health))
