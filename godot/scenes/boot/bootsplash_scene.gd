class_name BootsplashScene
extends Control

@export var fade_duration:float = 1.0
@export var stay_duration:float = 1.5
@export var node:PackedScene
@export var next_scene:PackedScene
@export var interuptable:bool = true

@onready var control = %NodeContainer
@onready var instance:Node2D = node.instantiate()

func _ready():
	instance.modulate.a = 0.0
	control.add_child(instance)
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(instance, "modulate:a", 1.0, fade_duration)\
	.from(0.0)\
	.finished.connect(_fade_out)

func _process(_delta):
	if interuptable and Input.is_action_just_pressed("exit"):
		_change_scene()
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_SPACE or event.keycode == KEY_ENTER:
			_change_scene()
	if event is InputEventMouseButton:
		if event.button_index == 1:
			_change_scene()
func _fade_out():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(instance, "modulate:a", 0.0, fade_duration)\
	.set_delay(stay_duration)\
	.finished.connect(_change_scene)

func _change_scene():
	get_tree().change_scene_to_packed(next_scene)
