class_name MapNode
extends Control

signal pressed

const margin = 16

var children: Array = []

@export_file("*.svg") var icons: Array[String] = []
enum MAP_ICON {COMBAT, ELITE, MYSTERY, SHOP, BOSS, CAMPFIRE, CURRENT}

@export var button: Button

func add_child_event(child) -> void:
	if !children.has(child):
		children.append(child)
		queue_redraw()

func set_type(icon: MAP_ICON) -> void:
	button.icon = ResourceLoader.load(icons[icon])

func enable() -> void:
	button.disabled = false
	button.pressed.connect(pressed.emit)

func _draw():
	for child in children:
		var line = child.position - position
		var normal = line.normalized()
		line -= margin * normal
		var color = Color.GRAY
		draw_line(normal * margin, line, color, 2)