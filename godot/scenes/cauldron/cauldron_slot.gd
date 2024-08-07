class_name CauldronSlot
extends PanelContainer

@export var ingredient_block_scene: PackedScene


var board_position: Vector2
var available: bool = true :
	set(value):
		available = value
		if available:
			# could make this the rarity/background of the ingredient instead of debug colors
			modulate = Color.WHITE
		else:
			modulate = Color.RED
var ingredient: Ingredient
var parent: CauldronSlot
var block_rotation: float


func _notification(what:int)->void:
	if what == Node.NOTIFICATION_DRAG_END and ingredient:
		modulate = ingredient.color