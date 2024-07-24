class_name Enemy
extends Resource



@export var name: String
@export_file('*.svg') var sprite: String
@export var actions: Array[EnemyActionEntry] = []
@export var stats: Stats
