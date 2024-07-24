class_name MapData
extends Resource

var paths = []
var nodes = {}

func set_paths(paths, points):
	self.paths = paths
	
	for path in paths:
		for id in path:
			nodes[id] = points[id]