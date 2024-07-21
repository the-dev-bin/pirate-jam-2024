class_name ItemDrag

signal drag_completed(data:ItemDrag)

var source: Control = null
var destination: Control = null

var item: Ingredient
var preview: Control
var block_rotation: float

func _init(_source: Control, _item: Ingredient, _preview: Control):
    self.source = _source
    self.item = _item
    self.preview = _preview
    self.preview.tree_exiting.connect(_on_tree_exiting)
    self.block_rotation = 0

func _on_tree_exiting()->void:
    drag_completed.emit(self)