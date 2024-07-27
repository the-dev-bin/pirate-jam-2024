class_name IngredientSelectMenu
extends CanvasLayer

@export var ingredient_card_scene: PackedScene

@onready var selection_container: HBoxContainer = %SelectionContainer

signal card_selected

func _ready() -> void:
	for child in %SelectionContainer.get_children():
		child.queue_free()

func setup(ingredients: Array[Ingredient]):
	for ingredient in ingredients:
		var temp: IngredientCard = ingredient_card_scene.instantiate()
		selection_container.add_child(temp)
		temp.setup(ingredient)
		temp.pressed.connect(_on_card_selected.bind(ingredient))


func _on_card_selected(ingredient: Ingredient):
	State.player_deck.push_back(ingredient)
	card_selected.emit()

