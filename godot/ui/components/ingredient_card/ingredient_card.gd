class_name IngredientCard
extends Button

@onready var name_label: Label = %NameLabel
@onready var block_container: CenterContainer = %BlockContainer
@onready var description_label: Label = %DescriptionLabel

@export var ingredient_block_scene: PackedScene


func _ready() -> void:
	# do some hover style stuff here eventually?
	pass # Replace with function body.

func setup(ingredient: Ingredient) -> void:
	var block: IngredientBlock = ingredient_block_scene.instantiate()
	block.setup(ingredient)
	block.on_board = true # this just disables the drag stuff
	block_container.add_child(block)
	name_label.text = ingredient.ingredient_name