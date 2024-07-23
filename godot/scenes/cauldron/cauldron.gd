class_name Cauldron
extends PanelContainer

@onready var slot_container: GridContainer = %SlotContainer
@export var preview_scene: PackedScene
@export var block_scene: PackedScene
signal toggle_tooltip(ingredient: Ingredient, position: Variant)

# fill out when blocks are placed
var board_state : Dictionary = {

}
@export var board_width: int = 5
@export var board_height: int = 5

var pieces_on_board : Array[Ingredient] = []
var hovering: bool = false
func _ready() -> void:
	var slot_container_children : Array[Node] = slot_container.get_children()
	for i in slot_container_children.size():
		var slot: Node = slot_container_children[i]
		if slot is CauldronSlot:
			# this currently only works with squarish shapes, not rectangles. TODO: make this better
			var x: int = i / board_width
			var y: int= i % board_height
			var board_position: Vector2 = Vector2(x,y)
			if !board_state.has(str(x)):
				board_state[str(x)] = {}
			board_state[str(x)][str(y)] = slot
			slot.board_position = board_position
	# init cauldron slot stuff, need a way of handling dynamic shapes of cauldrons. might have upgrades to shape later


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var cell : CauldronSlot = get_cell(get_global_mouse_position())
		if get_viewport().gui_is_dragging():
			return
		if cell and cell is CauldronSlot and cell.ingredient:
			hovering = true
			toggle_tooltip.emit(cell.ingredient, cell.global_position + Vector2(30,30))
		elif hovering:
			hovering = false
			toggle_tooltip.emit(null,null)



func _get_drag_data(_at_position:Vector2)->Variant:
	var mouse: Vector2 = get_global_mouse_position()
	var hovered_node: CauldronSlot = get_cell(mouse)
	if hovered_node and hovered_node is CauldronSlot and hovered_node.ingredient:
		toggle_tooltip.emit(null,null)
		var preview: IngredientBlock = preview_scene.instantiate()
		var ingredient_copy: Ingredient = hovered_node.ingredient.duplicate()
		# ingredient_copy.block_rotation = 0.0
		preview.setup(ingredient_copy)
		var drag_data : ItemDrag = ItemDrag.new(hovered_node, ingredient_copy, preview)
		set_drag_preview(preview)
		if hovered_node.parent:
			hovered_node.parent.get_child(0).modulate = Color(1.0,1.0,1.0,0.4)
		else:
			hovered_node.get_child(0).modulate = Color(1.0,1.0,1.0,0.4)
		return drag_data
	return null # make this the other way around
	# need to make it so you can move block to a place that it currently resides in, need to toggle then add a check on drag end to check if successful and revert if not

func get_cell(coords: Vector2) -> CauldronSlot:
	for node in slot_container.get_children() as Array[CauldronSlot]:
		if node.get_global_rect().has_point(coords):
			return node
	return null

func is_block_placeable(x: int, y: int, structure: Array[Vector2]) -> bool:
	if x < 0 or y < 0:
		return false
	if !is_slot_available(str(x),str(y)):
		return false
	for diff in structure:
		if x + diff.x > board_width or y + diff.y > board_height:
			return false
		if !is_slot_available(str(x + diff.x), str(y + diff.y)):
			return false
	return true

func is_slot_available(x: String,y: String) -> bool:
	if board_state.has(x):
		if board_state[x].has(y):
			return board_state[x][y].available
	return false


func _can_drop_data(_at_position:Vector2, data:Variant) -> bool:
	if !data is ItemDrag: return false
	var drag_data: ItemDrag = data
	var mouse: Vector2 = get_global_mouse_position()

	var hovered_node: CauldronSlot = get_cell(mouse)
	if hovered_node:
		# could probably do something here for styles to show better that it won't fit in the place
		return is_block_placeable(hovered_node.board_position.x, hovered_node.board_position.y, drag_data.item.get_structure(drag_data.block_rotation))
	else:
		return false

func toggle_availablity_block(board_position: Vector2, offsets: Array[Vector2], data=null, parent=null) -> void:
	board_state[str(board_position.x)][str(board_position.y)].available = !board_state[str(board_position.x)][str(board_position.y)].available
	for offset in offsets:
		var offset_node = board_state[str(board_position.x + offset.x)][str(board_position.y + offset.y)]
		if offset_node is CauldronSlot:
			offset_node.parent = parent
			offset_node.ingredient = data
			offset_node.available = !offset_node.available

func _drop_data(_at_position:Vector2, data:Variant)->void:
	if !data is ItemDrag: return
	var drag_data: ItemDrag = data
	var mouse: Vector2 = get_global_mouse_position()

	drag_data.destination = get_cell(mouse)

	var temp : IngredientBlock = block_scene.instantiate()
	temp.on_board = true
	temp.setup(data.item)
	drag_data.destination.available = false

	drag_data.destination.ingredient = drag_data.item
	if drag_data.source is CauldronSlot:
		drag_data.source.ingredient = null
		if drag_data.source.parent:
			drag_data.source = drag_data.source.parent
			drag_data.source.remove_child(drag_data.source.parent.get_child(0))
		else:
			drag_data.source.remove_child(drag_data.source.get_child(0))
		toggle_availablity_block(drag_data.source.board_position, drag_data.item.get_structure(drag_data.source.block_rotation))

		drag_data.source.available = true
	elif drag_data.source:
		pieces_on_board.push_back(drag_data.item)
		drag_data.source.removed_from_pouch.emit()
	drag_data.destination.add_child(temp)
	drag_data.destination.block_rotation = drag_data.block_rotation
	# temp.rotation_degrees = drag_data.block_rotation
	toggle_availablity_block(drag_data.destination.board_position, drag_data.item.get_structure(drag_data.block_rotation), drag_data.item, drag_data.destination)
