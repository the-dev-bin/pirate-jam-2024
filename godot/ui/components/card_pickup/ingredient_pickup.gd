class_name IngredientPickup
extends Button



@export var ingredient_select_menu: PackedScene
var ingredients: Array[Ingredient] = []


func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	disabled = true
	print('test')
	var select_menu: IngredientSelectMenu = ingredient_select_menu.instantiate()
	add_child(select_menu)
	select_menu.setup(ingredients)
	select_menu.card_selected.connect(_on_card_selected.bind(select_menu))

func _on_card_selected(node: Node):
	node.queue_free()
	visible = false
	
