class_name Ingredient
extends Resource

enum RARITY {COMMON, UNCOMMON, RARE, EPIC}

@export var ingredient_name: String
@export_file('*.svg') var image
# Define all places that should filled in by the position
@export var action: IngredientAction # should probably use packed scenes like the other method

@export_category('Rotations')
@export var base_structure: Array[Vector2] = [Vector2(0,0)]
@export var right_structure: Array[Vector2] = [Vector2(0,0)]
@export var flipped_structure: Array[Vector2] = [Vector2(0,0)]
@export var left_structure: Array[Vector2] = [Vector2(0,0)]

var tags: Array[String] = []
var rarity: RARITY



func get_structure(direction: float) -> Array[Vector2]:
	if direction == 0.0:
		return base_structure
	elif direction == 90.0:
		return left_structure
	elif direction == 180.0:
		return flipped_structure
	elif direction == 270.0:
		return right_structure
	printerr('Direction not found')
	return []
