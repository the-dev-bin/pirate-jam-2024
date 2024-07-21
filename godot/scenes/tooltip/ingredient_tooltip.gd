extends PanelContainer

@onready var name_label = %NameLabel

func _ready() -> void:
	visible = false


func setup(ingredient: Ingredient):
	name_label.text = ingredient.ingredient_name