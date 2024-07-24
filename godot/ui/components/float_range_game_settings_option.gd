extends HSlider

@export var property:String = ""

var initialised: bool= false

func _ready() -> void:
	value = UserSettings.get_value(property)

func _on_float_range_game_settings_option_value_changed(val: Variant) -> void:
	if !initialised:
		initialised = true
	UserSettings.set_value(property, val)
