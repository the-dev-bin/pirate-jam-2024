class_name ComponentPouch
extends PanelContainer

@onready var ingredient_container: BoxContainer = %IngredientContainer

signal toggle_tooltip(ingredient: Ingredient, position: Vector2)

@export var spawn_zone: Control # this will just be for coords to spawn and then tween to their actual position on the board
@export var ingredient_block_scene: PackedScene

var trash: Array[Ingredient] = []
var deck: Array[Ingredient] = []

func _ready() -> void:
	deck = State.player_deck
	deck.shuffle()
	# have some hand size variable here, for now this works tho
	pull_block()
	pull_block()

func toggle_tooltip_node(node: IngredientBlock, type: bool) -> void:
	if type:
		toggle_tooltip.emit(node.ingredient_resource, node.global_position + Vector2(30,30))
	else:
		toggle_tooltip.emit(null,null)

func pull_block() -> void:
	if deck.size() <= 0:
		deck = trash
		deck.shuffle()
		trash = []
	if deck.size() == 0:
		return
	var temp: IngredientBlock = ingredient_block_scene.instantiate()
	var resource: Ingredient = deck.pop_front()
	temp.setup(resource)
	temp.visible = false
	ingredient_container.add_child(temp)
	temp.mouse_entered.connect(toggle_tooltip_node.bind(temp, true))
	temp.mouse_exited.connect(toggle_tooltip_node.bind(temp, false))
	temp.removed_from_pouch.connect(_on_ingredient_removed.bind(temp))
	# call_deferred("move_block",temp)
	# this gets super wonky with, https://github.com/godotengine/godot/issues/30113
	# need to do some more poking to get this working right
	temp.visible = true


func move_block(node: IngredientBlock) -> void:
	var saved_position: Vector2 = node.get_global_rect().position
	node.global_position = spawn_zone.get_global_rect().position
	node.visible = true
	create_tween().tween_property(node, 'global_position', saved_position, 0.5)


func _on_ingredient_removed(ingredient_block: IngredientBlock) -> void:
	ingredient_block.queue_free()
	trash.push_back(ingredient_block.ingredient_resource)
	pull_block()
