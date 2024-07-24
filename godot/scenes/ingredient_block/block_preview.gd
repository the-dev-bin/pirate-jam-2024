extends IngredientBlock

var rotations: Array[int] = [0, 270, 180, 90]
var current_rotation : int = 0
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("rotate_left"):
		update_drag_data(-1)
	elif Input.is_action_just_pressed("rotate_right"):
		update_drag_data(1)


func update_drag_data(delta: int) -> void:
	if current_rotation + delta > rotations.size()-1:
		current_rotation = 0
	elif current_rotation + delta < 0:
		current_rotation = rotations.size()-1
	else:
		current_rotation += delta
	var drag_data : ItemDrag = get_viewport().gui_get_drag_data()
	drag_data.block_rotation = rotations[current_rotation]
	rotation_degrees = float(rotations[current_rotation])