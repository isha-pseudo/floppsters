extends StaticBody3D

@export_enum("weight", "fluffiness", "friction", "elasticity", "cushion") var stat_to_change: String = "fluffiness"
@export var change_amount: float = 0.2

@onready var stat_label: Label3D = $StatLabel

var player_controller = null

func _ready():
	
	update_label()

func interact(player_controller) -> void:
	if player_controller.handler == null or player_controller.handler.base_stats == null:
		return
		
	self.player_controller = player_controller
	
	var base = player_controller.handler.base_stats
	
	if stat_to_change in ["weight", "fluffiness", "friction", "elasticity", "cushion"]:
		var current = base.get(stat_to_change)
		base.set(stat_to_change, current + change_amount)
		update_label()
		
func update_label():
	if stat_label == null:
		print ("error no label")
		return
	var player_handler = player_controller.handler if player_controller else null
	var current_value = 0.0
	if player_controller:
		current_value = player_controller.handler.base_stats.get(stat_to_change)
	stat_label.text = stat_to_change.capitalize() + " " + ("+" if change_amount >= 0 else "") + str(change_amount) + " (Current: " + str(current_value) + ")"
