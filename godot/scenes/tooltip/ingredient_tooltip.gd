class_name IngredientTooltip
extends PanelContainer

@onready var name_label : Label = %NameLabel
@onready var ability_label: Label = %AbilityLabel

func _ready() -> void:
	visible = false


func setup(ingredient: Ingredient) -> void:
	name_label.text = ingredient.ingredient_name
	ability_label.text = ingredient.action.to_string()

func _process(delta: float) -> void:
	var mouse = get_global_mouse_position()
	global_position = mouse + Vector2(20,20)