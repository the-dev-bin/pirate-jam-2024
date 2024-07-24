class_name EnemySpawnZone
extends Resource


@export var encounters: Array[EnemySpawnEntry]

func get_encounter() -> EnemySpawnEntry:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	var weights: Array = encounters.map(get_weights)

	return encounters[rng.rand_weighted(weights)]


func get_weights(spawn_entry: EnemySpawnEntry) -> float:
	return spawn_entry.likelihood