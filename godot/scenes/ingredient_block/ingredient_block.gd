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

	modulate = Color(1.0,1.0,1.0,0.4)

	return drag_data

func _notification(what:int)->void:
	if what == Node.NOTIFICATION_DRAG_END:
		modulate = Color.WHITE