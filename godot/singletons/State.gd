extends Node

var player_deck : Array[Ingredient] = [load("res://ingredients/resources/godot_single.tres"),load("res://ingredients/resources/l_block.tres")]


var map_data: MapData
var current_map_node: int = 0
var total_nodes_passed: int = 0
var map_node_parameters: Dictionary = {}