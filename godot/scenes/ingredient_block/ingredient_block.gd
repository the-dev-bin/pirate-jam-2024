class_name IngredientBlock
extends Control

@export var preview_scene: PackedScene
@export var ingredient_resource: Ingredient
@export var block_size: int = 32
var max_height: float = 0
var max_width: float = 0

signal removed_from_pouch(ingredient: Ingredient)

var on_board = false

func _ready():
	setup(ingredient_resource)


func setup(_block_data: Ingredient) -> void:
	if !_block_data and !ingredient_resource:
		return
	ingredient_resource = _block_data
	parse_structure(ingredient_resource.base_structure)
	var size_vector: Vector2 = Vector2(max_width * block_size + block_size, max_height * block_size + block_size )
	# size = size_vector
	# print(size_vector)
	# set_deferred('size', size_vector)
	# pivot_offset = Vector2(16,16)
	# set_deferred('size', size_vector)
	$TextureRect.size = size_vector
	$TextureRect.texture = ResourceLoader.load(ingredient_resource.image)
	if on_board:
		mouse_filter = MOUSE_FILTER_IGNORE
	modulate = ingredient_resource.color

func parse_structure(points: Array[Vector2]) -> void:
	for point in points:
		if point[0] > max_width:
			max_width = point[0]
		if point[1] > max_height:
			max_height = point[1]



func _get_drag_data(_at_position:Vector2)->Variant:
	if on_board:
		return null

	var preview: IngredientBlock = preview_scene.instantiate()
	preview.setup(ingredient_resource)
	var drag_data: ItemDrag = ItemDrag.new(self, ingredient_resource, preview)
	set_drag_preview(drag_data.preview)

	modulate = Color(1.0,1.0,1.0,0.4)

	return drag_data

func _notification(what:int)->void:
	if what == Node.NOTIFICATION_DRAG_END:
		modulate = ingredient_resource.color