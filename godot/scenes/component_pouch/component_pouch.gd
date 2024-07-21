extends PanelContainer

@onready var ingredient_container = %IngredientContainer

signal toggle_tooltip(ingredient, position)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in ingredient_container.get_children():
		child.mouse_entered.connect(toggle_tooltip_node.bind(child, true))
		child.mouse_exited.connect(toggle_tooltip_node.bind(child, false))

func toggle_tooltip_node(node, type):
	if type:
		toggle_tooltip.emit(node.ingredient_resource, node.global_position + Vector2(30,30))
	else:
		toggle_tooltip.emit(null,null)