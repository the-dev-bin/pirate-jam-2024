extends Control

@export var combat_area: PackedScene
@export var treasure_room: PackedScene
@export var shop: PackedScene

@export var map_node: PackedScene
@export var map_scale = 1.0
@export var distance_apart: float = 1.0
@export var total_nodes = 12
var map_nodes = {}

@onready var map_node_container: Control = %MapNodeContainer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if State.map_data:
		pass
		# already exists
	else:
		var data: MapData = generate(30,total_nodes,12)
		State.map_data = data
	load_map(State.map_data)

func load_map(map_data: MapData) -> void:

	for child in map_node_container.get_children():
		child.queue_free()

	for k in map_data.nodes.keys():
		var point = map_data.nodes[k]
		var event = map_node.instantiate()
		event.position = point * map_scale + Vector2(200, 0)
		map_node_container.add_child(event)
		map_nodes[k] = event

	for path in map_data.paths:
		for i in range(path.size() - 1):
			var index1 = path[i]
			var index2 = path[i + 1]
			map_nodes[index1].add_child_event(map_nodes[index2])
	var current_node: MapNode = map_nodes[State.current_map_node]
	current_node.set_type(MapNode.MAP_ICON.CURRENT)

func _input(event: InputEvent) -> void:
	# just for testing out generating maps for now
	if event is InputEventMouseButton:
		if event.pressed:
			var data: MapData = generate(30,total_nodes,12)
			State.map_data = data
			load_map(State.map_data)
			
func _on_enemy_button_pressed():
	var enemy_encounter_button: CombatNode = %EnemyEncounterButton
	var encounter: EnemySpawnEntry = enemy_encounter_button.spawn_zone.get_encounter()
	print(encounter.enemies[0].name)
	State.map_node_parameters = enemy_encounter_button.get_params()
	get_tree().change_scene_to_packed(combat_area)


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
	return data
