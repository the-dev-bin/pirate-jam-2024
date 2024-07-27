extends Control

@export var map_scale: float = 1.0
@export var distance_apart: float = 1.0
@export var total_nodes:int = 12
@export_subgroup("Spawn pools")
@export var enemy_spawn_zones: Array[EnemySpawnZone] = []
@export var enemy_loot_pools: Array[LootTable] = []
@export var elite_loot_pools: Array[EnemySpawnZone] = []
@export var treasure_loot_pools: Array[LootTable] = []
@export var mystery_event_pools: Array[EnemySpawnZone] = []
enum LOOT_PROGRESSION {START, START_MID, MID, MID_END, END}
@export_subgroup("Packed Scenes")
@export var combat_area: PackedScene
@export var treasure_room: PackedScene
@export var shop: PackedScene
@export var map_node: PackedScene
@export var inventory_screen: PackedScene
var map_nodes = {}
@onready var map_node_container: Control = %MapNodeContainer
@onready var fade_overlay: FadeOverlay = %FadeOverlay
@onready var inventory_button: Button = %InventoryButton


var queued_scene: PackedScene

func _ready() -> void:
	fade_overlay.on_complete_fade_out.connect(_on_fade_out_complete)
	inventory_button.pressed.connect(_on_inventory_button_pressed)
	setup_map()

func setup_map():
	State.map_node_parameters = {}
	if State.map_data:
		pass
	else:
		var data: MapData = generate(30,total_nodes,12)
		State.map_data = data
	load_map(State.map_data)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_R and event.pressed:
			State.map_data = null
			setup_map()

func load_map(map_data: MapData) -> void:
	map_nodes = {}
	for child in map_node_container.get_children():
		child.queue_free()

	for k in map_data.nodes.keys():
		var point = map_data.nodes[k]
		var event: MapNode = map_node.instantiate()
		event.position = point * map_scale + Vector2(200, 0)
		map_node_container.add_child(event)
		event.set_type(map_data.node_types[k])
		map_nodes[k] = event

	for path in map_data.paths:
		for i in range(path.size() - 1):
			var index1 = path[i]
			var index2 = path[i + 1]
			map_nodes[index1].add_child_event(map_nodes[index2])
	var current_node: MapNode = map_nodes[State.current_map_node]
	current_node.set_type(MapNode.NODE_TYPE.CURRENT)
	current_node.enable() # just to get the styling right
	if current_node.children:
		for child in current_node.children:
			child.enable()
			var index: int = 0
			for thing in map_nodes.keys():
				if map_nodes[thing] == child:
					index = thing
					break
			child.pressed.connect(_on_map_node_pressed.bind(index))

func _on_map_node_pressed(index: int) -> void:
	print('Pressed ' + str(index))

	var current_node: MapNode = map_nodes[State.current_map_node]
	State.current_map_node = index
	var current_node_type: MapNode.NODE_TYPE = State.map_data.node_types[index]
	if current_node_type == MapNode.NODE_TYPE.COMBAT:
		var encounter: EnemySpawnEntry = enemy_spawn_zones[0].get_encounter()
		print(encounter.enemies[0].name)
		queued_scene = combat_area
		State.map_node_parameters = {
			"enemies": encounter.enemies,
			"loot": null
		}
	elif current_node_type == MapNode.NODE_TYPE.BOSS:
		var encounter: EnemySpawnEntry = enemy_spawn_zones[0].get_encounter()
		print(encounter.enemies[0].name)
		queued_scene = combat_area
		State.map_node_parameters = {
			"enemies": encounter.enemies,
			"loot": null,
			"boss": true
		}
	elif current_node_type == MapNode.NODE_TYPE.TREASURE:
		var loot: LootTable = treasure_loot_pools[0]
		queued_scene = treasure_room
		State.map_node_parameters = {
			"loot": loot
		}
	elif current_node_type == MapNode.NODE_TYPE.CAMPFIRE:
		# for now just heal the player?
		State.player_stats.current_health = State.player_stats.max_health
	elif current_node_type == MapNode.NODE_TYPE.ELITE:
		var encounter: EnemySpawnEntry = enemy_spawn_zones[0].get_encounter()
		print(encounter.enemies[0].name)
		queued_scene = combat_area
		State.map_node_parameters = {
			"enemies": encounter.enemies,
			"loot": null
		}
	elif current_node_type == MapNode.NODE_TYPE.MYSTERY:
		var choice: int= randi_range(0,1)
		if choice > 0:
			var encounter: EnemySpawnEntry = enemy_spawn_zones[0].get_encounter()
			queued_scene = combat_area
			State.map_node_parameters = {
				"enemies": encounter.enemies,
				"loot": null
			}
		else:
			var loot: LootTable = treasure_loot_pools[0]
			queued_scene = treasure_room
			State.map_node_parameters = {
				"loot": loot
			}

	fade_overlay.visible = true
	fade_overlay.fade_out()
	var temp: MapNode = map_node.instantiate()
	map_node_container.add_child(temp)
	temp.global_position = current_node.global_position
	temp.set_type(MapNode.NODE_TYPE.CURRENT)
	current_node.set_type(MapNode.NODE_TYPE.EMPTY)
	var tween = create_tween()
	tween.tween_property(temp, "global_position", map_nodes[index].global_position, 0.5)


func _on_fade_out_complete() -> void:
	if queued_scene:
		get_tree().change_scene_to_packed(queued_scene)
	else:
		load_map(State.map_data)
		fade_overlay.fade_in()




# this is from https://github.com/VladoCC/Map-Generator-Godot-Tutorial
# might need some tweaking to get exactly what we want
func generate(plane_len: int, node_count: int, path_count: int) -> MapData:
	# make sure that we are not going to generate the same map every time
	randomize()

	# step 1: generating points on a grid randomly
	var points: Array= []
	points.append(Vector2(0, plane_len / 2))
	points.append(Vector2(plane_len, plane_len / 2))

	var center: Vector2 = Vector2(plane_len / 2, plane_len / 2)
	for i in range(node_count):
		while true:
			var point = Vector2(randi() % plane_len, randi() % plane_len)

			var dist_from_center = (point - center).length_squared()
			# only accept points insode of a circle
			var in_circle = dist_from_center <= plane_len * plane_len / 4
			var min_distance = INF
			for thing in points:
				if (point - thing).length_squared() < min_distance:
					min_distance = (point - thing).length_squared()
			if not points.has(point) and in_circle and min_distance > distance_apart:
				points.append(point)
				break

	# step 2: connect all the points into a graph without intersecting edges
	var pool: PackedVector2Array = PackedVector2Array(points)
	var triangles : PackedInt32Array = Geometry2D.triangulate_delaunay(pool)

	# step 3: finding paths from start to finish using A*
	var astar: AStar2D = AStar2D.new()
	for i in range(points.size()):
		astar.add_point(i, points[i])

	for i in range(triangles.size() / 3):
		var p1 = triangles[i * 3]
		var p2 = triangles[i * 3 + 1]
		var p3 = triangles[i * 3 + 2]
		if not astar.are_points_connected(p1, p2):
			astar.connect_points(p1, p2)
		if not astar.are_points_connected(p2, p3):
			astar.connect_points(p2, p3)
		if not astar.are_points_connected(p1, p3):
			astar.connect_points(p1, p3)

	var paths: Array = []

	for i in range(path_count):
		var id_path: PackedInt64Array = astar.get_id_path(0, 1)
		if id_path.size() == 0:
			break

		paths.append(id_path)

		# step 4: removing nodes / generating unique path every time
		for j in range(randi() % 2 + 1):
			# index between 1 and id_path.size() - 2 (inclusive)
			var index: int= randi() % (id_path.size() - 2) + 1

			var id = id_path[index]
			astar.set_point_disabled(id)

	var data: MapData = MapData.new()
	data.set_paths(paths, points)
	data.node_types = {}

	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	var weights: Array = [
		10.0, # COMBAT
		3.0, # ELITE
		7.0, # MYSTERY
		5.0, # TREASURE
		]

	var total_combat: int = 0
	while total_combat < total_nodes / 2:
		total_combat = 0
		for node in data.nodes.keys():
			# basically random for now, eventually do stuff with checking connected nodes
			var genned_type: int = rng.rand_weighted(weights)
			if genned_type == MapNode.NODE_TYPE.COMBAT:
				total_combat += 1
			data.node_types[node] = genned_type
		data.node_types[0] = MapNode.NODE_TYPE.START
		data.node_types[1] = MapNode.NODE_TYPE.BOSS
		for i in data.paths.size(): # this technically messes with the total combat calc /shrug
			var path: PackedInt64Array = data.paths[i]
			# if path.size() > 3 and data.node_types[path[3]] != MapNode.NODE_TYPE.BOSS:
			# 	data.node_types[path[3]] = MapNode.NODE_TYPE.CAMPFIRE
			if path[path.size()-2] and path[path.size()-2] and data.node_types[path[path.size() -2]] != MapNode.NODE_TYPE.BOSS:
				data.node_types[path[path.size()-2]] = MapNode.NODE_TYPE.CAMPFIRE
		for i in data.paths.size():
			var path: PackedInt64Array = data.paths[i]
			if path.size() < 3:
				total_combat = 0
	# also need to figure out resting spots
	return data


func _on_inventory_button_pressed():
	print('asdboubwe')
	var temp = inventory_screen.instantiate()
	$CanvasLayer.add_child(temp)
