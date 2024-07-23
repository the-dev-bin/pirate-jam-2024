extends Node2D


@onready var cauldron : Cauldron = %Cauldron
@onready var ingredient_pouch : ComponentPouch = %ComponentPouch
@onready var ingredient_tooltip : IngredientTooltip = %IngredientTooltip
func _ready() -> void:
	cauldron.toggle_tooltip.connect(_on_toggle_tooltip)
	ingredient_pouch.toggle_tooltip.connect(_on_toggle_tooltip)

	var enemy_spawn_point: EnemySpawnPoint = $EnemySpawnPoint
	enemy_spawn_point.spawn_enemy(load("res://enemies/godot_enemy.tres")) # for now just spawn in an enemy manually, later have defined encounters that we load in



func _on_toggle_tooltip(ingredient: Ingredient, tooltip_position: Variant) -> void:
	if ingredient:
		ingredient_tooltip.visible = true
		ingredient_tooltip.global_position = tooltip_position
		ingredient_tooltip.setup(ingredient)
	else:
		ingredient_tooltip.visible = false