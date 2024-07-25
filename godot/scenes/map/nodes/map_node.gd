class_name MapNode
extends Control

const margin = 16

var children: Array = []

@export_file("*.svg") var icons: Array[String] = []
enum MAP_ICON {COMBAT, ELITE, MYSTERY, SHOP, BOSS, CAMPFIRE, CURRENT}

@export var button: Button

func add_child_event(child):
	if !children.has(child):
		children.append(child)
		queue_redraw()

func set_type(icon: MAP_ICON):
	#
	button.icon = ResourceLoader.load(icons[icon])


func _draw():
	for child in children:
		var line = child.position - position
		var normal = line.normalized()
		line -= margin * normal
		var color = Color.GRAY
		draw_line(normal * margin, line, color, 2)