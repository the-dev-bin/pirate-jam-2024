extends Node

var player_deck : Array[Ingredient] = [load("res://scenes/ingredient_block/resources/godot_single.tres"),load("res://scenes/ingredient_block/resources/l_block.tres")]


var map_data: MapData
var current_map_node: int = 0
var map_node_parameters: Dictionary = {}