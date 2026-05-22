extends CanvasLayer

@onready var handler: CharacterHandler = get_parent().get_node("CharacterHandler")

@onready var title_label: Label = $ColorRect/StatsContainer/TitleLabel
@onready var weight_label: Label = $ColorRect/StatsContainer/WeightLabel
@onready var fluffiness_label: Label = $ColorRect/StatsContainer/FluffinessLabel
@onready var friction_label: Label = $ColorRect/StatsContainer/FrictionLabel
@onready var buzz_label: Label = $ColorRect/StatsContainer/BuzzLabel
@onready var max_speed_label: Label = $ColorRect/StatsContainer/MaxSpeedLabel

var is_visible: bool = false

func _ready() -> void:
	visible = false
	is_visible = false
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		is_visible = not is_visible
		visible = is_visible
	
	if is_visible:
		update_stats_display()
		
func update_stats_display():
	if handler == null:
		return
		
	else:
		var stats = handler.get_effective_stats()
		
		title_label.text = "Character: " + handler.base_stats.character_name
		weight_label.text = "Weight: " + str(stats.get("weight", 0.0))
		fluffiness_label.text = "Fluffiness: " + str(stats.get("fluffiness", 0.0))
		friction_label.text = "Friction: " + str(stats.get("friction", 0.0))
		buzz_label.text = "Current Buzz: " + str(stats.get("effective_buzz", 0.0))
		max_speed_label.text = "Max Speed: " + str(stats.get("effective_max_speed", 0.0))
