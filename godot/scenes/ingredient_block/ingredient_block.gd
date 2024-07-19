class_name IngredientBlock
extends Control

@export var block_data = 'godot'
@export var preview_scene: PackedScene


func setup(_block_data):
	# eventually this will handle complex block shapes and all that jazz
	pass

func _get_drag_data(_at_position:Vector2)->Variant:

	var preview = preview_scene.instantiate()
	preview.setup(block_data)
	var drag_data = ItemDrag.new(self, block_data, preview)
	set_drag_preview(drag_data.preview)

	return drag_data
