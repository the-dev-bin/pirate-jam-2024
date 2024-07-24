class_name IngredientTooltip
extends PanelContainer

@onready var name_label : Label = %NameLabel

func _ready() -> void:
	visible = false


func setup(ingredient: Ingredient) -> void:
	name_label.text = ingredient.ingredient_name