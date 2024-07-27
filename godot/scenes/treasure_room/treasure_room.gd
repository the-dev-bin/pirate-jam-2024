extends Control

@export var ingredient_pickup_button: PackedScene

@onready var interaction_container: VBoxContainer = %InteractionContainer
@onready var map_button: Button = %MapButton
func _ready() -> void:
	for child in interaction_container.get_children():
		child.queue_free()
	var temp: IngredientPickup =	ingredient_pickup_button.instantiate()
	var loot: LootTable = State.map_node_parameters['loot']
	var ingredients: Array[Ingredient] = []
	ingredients.assign(loot.get_loot(3).map(func(thing: LootTableEntry) -> Ingredient: return thing.ingredient))
	temp.ingredients = ingredients
	interaction_container.add_child(temp)

	map_button.pressed.connect(_on_map_button_pressed)

func _on_map_button_pressed():
	get_tree().change_scene_to_file("res://scenes/map/map.tscn")