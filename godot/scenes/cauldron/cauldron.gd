extends PanelContainer

@onready var slot_container = %SlotContainer
@export var preview_scene: PackedScene

# fill out when blocks are placed
var board_state = {

}
@export var board_width = 5
@export var board_height = 5

func _ready() -> void:
	var slot_container_children = slot_container.get_children()
	for i in slot_container_children.size():
		var slot = slot_container_children[i]
		if slot is CauldronSlot:
			# this currently only works with squarish shapes, not rectangles. TODO: make this better
			var x: int = i / board_width
			var y: int= i % board_height
			var board_position = Vector2(x,y)
			if !board_state.has(str(x)):
				board_state[str(x)] = {}
			board_state[str(x)][str(y)] = slot
			slot.board_position = board_position
	# init cauldron slot stuff, need a way of handling dynamic shapes of cauldrons. might have upgrades to shape later




func _get_drag_data(_at_position:Vector2)->Variant:
	var mouse = get_global_mouse_position()
	var hovered_node = get_cell(mouse)
	if hovered_node and hovered_node is CauldronSlot and hovered_node.ingredient:
		print('hitting node')
		print(hovered_node.board_position)
		var preview = preview_scene.instantiate()
		preview.setup(hovered_node.ingredient)
		var drag_data = ItemDrag.new(hovered_node, hovered_node.ingredient, preview)
		set_drag_preview(preview)
		hovered_node.get_child(0).modulate = Color(1.0,1.0,1.0,0.4)
		return drag_data
	return null # make this the other way around

func get_cell(coords):
	for node in slot_container.get_children() as Array[CauldronSlot]:
		if node.get_global_rect().has_point(coords):
			return node
	return null

func is_block_placeable(x, y, block: Ingredient):
	if x < 0 or y < 0:
		return false
	if !is_slot_available(str(x),str(y)):
		return false
	for diff in block.structure:
		if x + diff.x > board_width or y + diff.y > board_height:
			return false
		if !is_slot_available(str(x + diff.x), str(y + diff.y)):
			return false
	return true

func is_slot_available(x,y):
	if board_state.has(x):
		if board_state[x].has(y):
			return board_state[x][y].available
	return false

func _can_drop_data(_at_position:Vector2, data:Variant)->bool:
	if !data is ItemDrag: return false
	var drag_data := data as ItemDrag
	var mouse = get_global_mouse_position()

	var hovered_node = get_cell(mouse)
	if hovered_node:
		return is_block_placeable(hovered_node.board_position.x, hovered_node.board_position.y, drag_data.item)
	else:
		return false


func _drop_data(_at_position:Vector2, data:Variant)->void:
	if !data is ItemDrag: return
	var drag_data := data as ItemDrag
	var mouse = get_global_mouse_position()

	drag_data.destination = get_cell(mouse)
	var temp = preview_scene.instantiate()
	temp.on_board = true
	temp.setup(data.item)
	drag_data.destination.available = false

	drag_data.destination.ingredient = drag_data.item
	if drag_data.source is CauldronSlot:
		drag_data.source.ingredient = null
		drag_data.source.available = true
		drag_data.source.remove_child(drag_data.source.get_child(0))
		drag_data.source.available = true
	elif drag_data.source:
		drag_data.source.visible = false
	drag_data.destination.add_child(temp)
	# if block is bigger than one block need to go through and make the other nodes the correct thing
	# also means needs to keep track of the parent node for this
	# and maybe also the children for easier access stuff?
