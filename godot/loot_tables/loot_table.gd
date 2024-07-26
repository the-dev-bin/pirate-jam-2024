class_name LootTable
extends Resource

@export var loot: Array[LootTableEntry]
@export var money_range: Array[int] = [5,15] # might not use this yet, but eventually

func get_loot(quantity: int) -> Array[LootTableEntry]:
	var temp: Array[LootTableEntry] = loot.duplicate()
	var output: Array[LootTableEntry] = []
	randomize()
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	for i in quantity:
		var weights: Array = temp.map(get_weights)
		var index: int = rng.rand_weighted(weights)
		var item = temp.pop_at(index)
		if item:
			output.push_back(item)
	return output

func get_weights(loot_entry: LootTableEntry) -> float:
	return loot_entry.likelihood