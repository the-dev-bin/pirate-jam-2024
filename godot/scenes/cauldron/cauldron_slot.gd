extends PanelContainer

@export var ingredient_block_scene: PackedScene

signal block_dropped


func _can_drop_data(at_position:Vector2, data:Variant)->bool:
	if !data is ItemDrag: return false
	var drag_data := data as ItemDrag
	return true


func _drop_data(at_position:Vector2, data:Variant)->void:
	if !data is ItemDrag: return
	var drag_data := data as ItemDrag

	drag_data.destination = self
	if drag_data.source: drag_data.source.visible = false # TODO: remove process here, but not just deleting
	var temp = ingredient_block_scene.instantiate()
	add_child(temp)

	block_dropped.emit(data.item)