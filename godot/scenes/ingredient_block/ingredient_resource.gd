class_name Ingredient
extends Resource


enum RARITY {COMMON, UNCOMMON, RARE, EPIC}

@export_file('*.svg') var image
# Define all places that should filled in by the position
@export var structure: Array[Vector2] = [Vector2(0,0)]
@export var action: IngredientAction

var tags: Array[String] = []
var rarity: RARITY