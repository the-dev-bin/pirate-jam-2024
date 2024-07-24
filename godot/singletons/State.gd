extends Node

var player_deck : Array[Ingredient] = [load("res://scenes/ingredient_block/resources/godot_single.tres"),load("res://scenes/ingredient_block/resources/l_block.tres")]

class MapState:
	var position: Vector2

var map_data: MapData
var map_node_parameters: Dictionary = {}