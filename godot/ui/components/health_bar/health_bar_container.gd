extends PanelContainer

@onready var health_bar: ProgressBar = %HealthProgressBar

@onready var current_health_label: Label = %CurrentHealthLabel
@onready var max_health_label: Label = %MaxHealthLabel
func setup(max_value, current_value):
	health_bar.min_value = 0
	health_bar.max_value = max_value
	health_bar.value = current_value

	current_health_label.text = str(current_value)
	max_health_label.text = str(max_value)

func update_value(new_value):
	var tween: Tween = create_tween()
	tween.tween_property(health_bar, "value", new_value, 0.5)
	current_health_label.text = str(new_value)
