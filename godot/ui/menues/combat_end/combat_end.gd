class_name CombatEndScene
extends Control

@export var ingredient_button_scene: PackedScene

@onready var interaction_container: VBoxContainer = %InteractionContainer
@onready var map_button: Button = %MapButton

func _ready() -> void:
	map_button.pressed.connect(_on_map_button_pressed)

func setup(loot: LootTable) -> void:
	var temp: IngredientPickup = ingredient_button_scene.instantiate()
	var ingredients: Array[Ingredient] = []
	ingredients.assign(loot.get_loot(3).map(func(thing: LootTableEntry) -> Ingredient: return thing.ingredient))
	temp.ingredients = ingredients
	interaction_container.add_child(temp)

func _on_map_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/map/map.tscn") # evemtually have some check here to see if there's some leftover stuff