extends Node
class_name CharacterHandler

@export var base_stats : CharacterStats

var current_buzz: float = 10.0

var buzz_decay: float = 1.0

func _ready() -> void:
	if base_stats == null:
		push_warning ("Error : Failed to obtain stats")
	
func get_effective_stats() -> Dictionary:
	if base_stats == null:
		return {}
	
	var stats: Dictionary = {}
	
	## reads the base stats ##
	
	stats["weight"] = base_stats.weight
	stats["fluffiness"] = base_stats.fluffiness
	stats["friction"] = base_stats.friction
	stats["elasticity"] = base_stats.elasticity
	stats["cusion"] = base_stats.cushion
	
	## buzz calculation
	
	var max_buzz = base_stats.buzz
	
	stats["effective_buzz"] = current_buzz
	stats["max_buzz"] = max_buzz
	stats["max_momentum"] = 10.0
	
	## derived stats
	
	stats["effective_max_momentum"] = stats["max_momentum"]
	stats["effective_acceleration"] = 18 / stats["weight"]
	stats["effective_acceleration"] = 14.0 + (current_buzz * 0.8)
	
	print (stats)
	return stats
	
func update_current_buzz(is_moving:bool, delta: float) -> void:
	if not is_moving:
		current_buzz = max(0.0, current_buzz - buzz_decay * delta)
