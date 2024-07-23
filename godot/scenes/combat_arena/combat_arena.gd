extends Node2D


@onready var cauldron : Cauldron = %Cauldron
@onready var ingredient_pouch : ComponentPouch = %ComponentPouch
@onready var ingredient_tooltip : IngredientTooltip = %IngredientTooltip
func _ready() -> void:
	cauldron.toggle_tooltip.connect(_on_toggle_tooltip)
	ingredient_pouch.toggle_tooltip.connect(_on_toggle_tooltip)



func _on_toggle_tooltip(ingredient: Ingredient, tooltip_position: Vector2) -> void:
	if ingredient:
		ingredient_tooltip.visible = true
		ingredient_tooltip.global_position = tooltip_position
		ingredient_tooltip.setup(ingredient)
	else:
		ingredient_tooltip.visible = false