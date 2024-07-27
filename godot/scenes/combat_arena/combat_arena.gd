extends Node2D


@onready var cauldron: Cauldron = %Cauldron
@onready var ingredient_pouch: ComponentPouch = %ComponentPouch
@onready var ingredient_tooltip: IngredientTooltip = %IngredientTooltip
@onready var end_turn_button: Button = %EndTurnButton
@onready var player_node: Player = %Player
@onready var position_anchor: Control = %PositionAnchor


@export var combat_end_scene: PackedScene
@export var test_loot_table: LootTable

func _ready() -> void:
	%BattleEndButton.pressed.connect(end_battle)
	cauldron.toggle_tooltip.connect(_on_toggle_tooltip)
	ingredient_pouch.toggle_tooltip.connect(_on_toggle_tooltip)
	end_turn_button.pressed.connect(_on_end_turn_button_pressed)

	if State.map_node_parameters.has('enemies'):
		var enemies: Array[Enemy] = State.map_node_parameters['enemies']
		if enemies.size() > 2:
			printerr('Enemies list too long')
			return

		print(enemies)
	else:
		printerr('State did not pass enemies to node')
	var enemy_spawn_point: EnemySpawnPoint = $EnemySpawnPoint
	enemy_spawn_point.spawn_enemy(load("res://enemies/godot_enemy.tres")) # for now just spawn in an enemy manually, later have defined encounters that we load in
	var enemy: EnemyNode = enemy_spawn_point.get_enemy_node()
	enemy.update_intent()



func _on_toggle_tooltip(ingredient: Ingredient, tooltip_position: Variant) -> void:
	if ingredient:
		ingredient_tooltip.visible = true
		ingredient_tooltip.global_position = tooltip_position
		ingredient_tooltip.setup(ingredient)
	else:
		ingredient_tooltip.visible = false

func _on_end_turn_button_pressed():
	print('ending players turn')
	var enemy_spawn_point: EnemySpawnPoint = $EnemySpawnPoint
	var enemy: EnemyNode = enemy_spawn_point.get_enemy_node()
	for ingredient in cauldron.get_ingredients():
		if ingredient.action:
			ingredient.action.process_action(player_node, [enemy], 0)
	ingredient_pouch.add_blocks_to_trash(cauldron.get_ingredients())
	cauldron.clear_board()

	# again, should eventually take into account all enemies
	var action_entry: EnemyActionEntry = enemy.get_action()
	var action: EnemyAction = action_entry.scene.instantiate()
	add_child(action)
	action.process_action(player_node, [enemy], action_entry.params, enemy)
	enemy.update_intent()
	ingredient_pouch.clear_hand()
	ingredient_pouch.draw_hand()

func end_battle():
	var thing: CombatEndScene = combat_end_scene.instantiate()
	position_anchor.add_child(thing)
	thing.setup(test_loot_table)
	process_mode = PROCESS_MODE_DISABLED # pause background since we're done with battle and don't want interactions to work there
	# the anchor control node is setup to process always and isn't affected by this
