class_name CauldronSlot
extends PanelContainer

@export var ingredient_block_scene: PackedScene

signal block_dropped

var board_position : Vector2
var available = true
var ingredient: Ingredient
