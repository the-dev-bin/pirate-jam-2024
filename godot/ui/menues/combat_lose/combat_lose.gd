extends Control

@onready var main_menu_button: Button = %MainMenuButton

func _ready() -> void:
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)

func _on_main_menu_button_pressed() -> void:
	State._init()
	get_tree().change_scene_to_file("res://scenes/main_menu_scene.tscn")
