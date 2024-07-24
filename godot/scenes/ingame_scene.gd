extends Node2D

@onready var fade_overlay: FadeOverlay = %FadeOverlay
@onready var pause_overlay: PauseOverlay = %PauseOverlay
@onready var cauldron: Cauldron = %Cauldron
@onready var ingredient_pouch: ComponentPouch = %ComponentPouch
@onready var ingredient_tooltip: IngredientTooltip = %IngredientTooltip

func _ready() -> void:
	fade_overlay.visible = true

	if SaveGame.has_save():
		SaveGame.load_game(get_tree())

	pause_overlay.game_exited.connect(_save_game)
	cauldron.toggle_tooltip.connect(_on_toggle_tooltip)
	ingredient_pouch.toggle_tooltip.connect(_on_toggle_tooltip)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and not pause_overlay.visible:
		get_viewport().set_input_as_handled()
		get_tree().paused = true
		pause_overlay.grab_button_focus()
		pause_overlay.visible = true

func _save_game() -> void:
	SaveGame.save_game(get_tree())

func _on_toggle_tooltip(ingredient: Ingredient, tooltip_position: Variant) -> void:
	if ingredient:
		ingredient_tooltip.visible = true
		ingredient_tooltip.global_position = tooltip_position
		ingredient_tooltip.setup(ingredient)
	else:
		ingredient_tooltip.visible = false