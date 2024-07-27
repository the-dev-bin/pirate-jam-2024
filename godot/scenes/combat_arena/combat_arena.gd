extends Node2D


@onready var cauldron: Cauldron = %Cauldron
@onready var ingredient_pouch: ComponentPouch = %ComponentPouch
@onready var ingredient_tooltip: IngredientTooltip = %IngredientTooltip
@onready var end_turn_button: Button = %EndTurnButton
@onready var player_node: Player = %Player
@onready var position_anchor: CanvasLayer = %PositionAnchor


@export var combat_end_scene: PackedScene
@export var combat_lose_scene: PackedScene
@export var game_end_screen: PackedScene
@export var test_loot_table: LootTable

@export var enemy_spawns: Array[EnemySpawnPoint] = []
var enemy_nodes: Array[EnemyNode] = []

var currently_targeted_enemy: int

func _ready() -> void:
	cauldron.toggle_tooltip.connect(_on_toggle_tooltip)
	ingredient_pouch.toggle_tooltip.connect(_on_toggle_tooltip)
	end_turn_button.pressed.connect(_on_end_turn_button_pressed)
	State.player_stats.health_changed.connect(_on_player_health_changed)
	if State.map_node_parameters.has('enemies'):
		var enemies: Array[Enemy] = State.map_node_parameters['enemies']
		if enemies.size() > 2:
			printerr('Enemies list too long')
			return
		for i in enemies.size():
			var enemy_spawn_point: EnemySpawnPoint = enemy_spawns[i]
			enemy_spawn_point.spawn_enemy(enemies[i].duplicate(true))
			var enemy = enemy_spawn_point.get_enemy_node()
			enemy.update_intent()
			enemy_nodes.push_back(enemy)
			enemy_spawn_point.pressed.connect(_on_spawn_point_pressed.bind(i))
	else:
		printerr('State did not pass enemies to node')
		var enemy_spawn_point: EnemySpawnPoint = $EnemySpawnPoint
		enemy_spawn_point.spawn_enemy(load("res://enemies/godot_enemy.tres")) # for now just spawn in an enemy manually, later have defined encounters that we load in
		var enemy: EnemyNode = enemy_spawn_point.get_enemy_node()
		enemy.update_intent()
		enemy_spawn_point.pressed.connect(_on_spawn_point_pressed.bind(0))
		enemy_nodes.push_back(enemy)
	for enemy in enemy_spawns:
		enemy.set_selected_crosshair(false)
	


func _on_toggle_tooltip(ingredient: Ingredient, tooltip_position: Variant) -> void:
	if ingredient:
		ingredient_tooltip.visible = true
		ingredient_tooltip.global_position = tooltip_position
		ingredient_tooltip.setup(ingredient)
	else:
		ingredient_tooltip.visible = false

func _on_end_turn_button_pressed():
	print('ending players turn')
	# var enemy_spawn_point: EnemySpawnPoint = $EnemySpawnPoint
	# var enemy: EnemyNode = enemy_spawn_point.get_enemy_node()
	for ingredient in cauldron.get_ingredients():
		if ingredient.action:
			ingredient.action.process_action(player_node, enemy_nodes, currently_targeted_enemy)
	ingredient_pouch.add_blocks_to_trash(cauldron.get_ingredients())
	cauldron.clear_board()
	for enemy_spawn in get_alive_enemies():
		# again, should eventually take into account all enemies
		var enemy = enemy_spawn.get_enemy_node()
		var action_entry: EnemyActionEntry = enemy.get_action()
		var action: EnemyAction = action_entry.scene.instantiate()
		add_child(action)
		var alive_enemies : Array[EnemyNode] = []
		alive_enemies.assign(get_alive_enemies().map(func (node): return node.get_enemy_node()))
		action.process_action(player_node, alive_enemies , action_entry.params, enemy)
		enemy.update_intent()
		ingredient_pouch.clear_hand()
		ingredient_pouch.draw_hand()
	if get_alive_enemies().size() <= 0:
		end_battle()

func end_battle():
	if State.map_node_parameters.has('boss'):
		var thing = game_end_screen.instantiate()
		position_anchor.add_child(thing)
	else:
		var thing: CombatEndScene = combat_end_scene.instantiate()
		position_anchor.add_child(thing)
		thing.setup(test_loot_table)
	process_mode = PROCESS_MODE_DISABLED # pause background since we're done with battle and don't want interactions to work there
	# the anchor control node is setup to process always and isn't affected by this

func _on_player_health_changed(new_health):
	if new_health <= 0:
		var thing = combat_lose_scene.instantiate()
		position_anchor.add_child(thing)
		process_mode = PROCESS_MODE_DISABLED

func _on_spawn_point_pressed(index: int) -> void:
	for enemy in enemy_spawns:
		enemy.set_selected_crosshair(false)
	enemy_spawns[index].set_selected_crosshair(true)
	currently_targeted_enemy = index

func get_alive_enemies() -> Array[EnemySpawnPoint]:
	print(enemy_spawns[0].enemy)
	var temp = enemy_spawns.filter(func (spawn: EnemySpawnPoint): return spawn.enemy != null)
	return temp.filter(func (spawn: EnemySpawnPoint): return spawn.enemy.stats.current_health > 0)

func get_first_alive_enemy() -> EnemySpawnPoint:
	var temp = get_alive_enemies()
	return temp[0]
