class_name Player
extends Node2D

@export var max_health: int = 10
var current_health: int


func _ready() -> void:
	current_health = max_health # eventually make this carry over health between runs


func damage(value: int) -> void:
	current_health -= value
	print('current health ' + str(current_health))