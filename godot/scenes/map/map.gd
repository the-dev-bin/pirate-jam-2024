extends Control

@export var combat_area: PackedScene
@export var treasure_room: PackedScene
@export var shop: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%EnemyEncounterButton.pressed.connect(_on_enemy_button_pressed)


func _on_enemy_button_pressed():
	var enemy_encounter_button: CombatNode = %EnemyEncounterButton
	var encounter: EnemySpawnEntry = enemy_encounter_button.spawn_zone.get_encounter()
	print(encounter.enemies[0].name)
