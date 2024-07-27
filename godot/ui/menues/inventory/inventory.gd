extends CanvasLayer

@export var ingredient_card_scene: PackedScene

@onready var ingredients_container = %IngredientsContainer
@onready var close_button = %CloseButton
func _ready() -> void:
	update_cards(State.player_deck)
	close_button.pressed.connect(_on_close_button_pressed)

func update_cards(cards:Array[Ingredient] = []) -> void:
	for child in ingredients_container.get_children():
		child.queue_free()
	
	for ingredient in cards:
		var temp = ingredient_card_scene.instantiate()
		ingredients_container.add_child(temp)
		temp.setup(ingredient)

func _on_close_button_pressed():
	queue_free()