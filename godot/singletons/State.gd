extends Node

var player_deck : Array[Ingredient] = [load("res://ingredients/resources/godot_single.tres"),load("res://ingredients/resources/t_block.tres")]



var map_data: MapData
var current_map_node: int = 0
var total_nodes_passed: int = 0
var map_node_parameters: Dictionary = {}


var player_stats : Stats = Stats.new()

func _init(health: int = 5, max_health: int = 100) -> void:
  player_stats = Stats.new()
  player_stats.current_health = max_health
  player_stats.max_health = max_health
  player_deck = [
    load("res://ingredients/resources/godot_single.tres"),
    load("res://ingredients/resources/godot_single.tres"),
    load("res://ingredients/resources/godot_single.tres"),
    load("res://ingredients/resources/l_block.tres"),
    load("res://ingredients/resources/l_block.tres"),
    load("res://ingredients/resources/l_block.tres"),
    ]
  map_data = null
  total_nodes_passed = 0
  current_map_node = 0
  map_node_parameters = {}
  print('starting health ' + str(player_stats.current_health))

