class_name IngredientTooltip
extends PanelContainer

@onready var name_label : Label = %NameLabel
@onready var ability_label: Label = %AbilityLabel

func _ready() -> void:
	visible = false


func setup(ingredient: Ingredient) -> void:
	name_label.text = ingredient.ingredient_name
	ability_label.text = ingredient.action.to_string()