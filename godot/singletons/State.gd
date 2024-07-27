extends Node

var player_deck : Array[Ingredient] = [
  load("res://scenes/ingredient_block/resources/godot_single.tres"),
  load("res://scenes/ingredient_block/resources/l_block.tres")
]

var player_stats : Stats = Stats.new()

func _init(health: int = 5, max_health: int = 10) -> void:
  player_stats.current_health = health
  player_stats.max_health = max_health
  
  print('starting health ' + str(player_stats.current_health))
