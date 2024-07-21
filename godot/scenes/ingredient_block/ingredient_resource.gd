class_name Ingredient
extends Resource

@export_file('*.svg') var image
# Define all places that should filled in by the position
@export var structure: Array[Vector2] = [Vector2(0,0)]
