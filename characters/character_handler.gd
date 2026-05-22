extends Node
class_name CharacterHandler

@export var base_stats : CharacterStats

var current_buzz: float = 0.0

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
	stats["cushion"] = base_stats.cushion
	
	## buzz calculation
	
	var max_buzz = base_stats.max_buzz
	
	stats["effective_buzz"] = current_buzz
	stats["max_buzz"] = max_buzz
	
	
	stats["max_speed"] = base_stats.max_speed
	stats["effective_max_speed"] = base_stats.max_speed
	
	## derived stats
	#stats["effective_acceleration"] = 18 / stats["weight"]
	stats["effective_deceleration"] = 14.0 + (current_buzz * 0.8)
	stats["inertial_resistance"] = max(0.5, (stats["weight"] * 0.3) - stats["friction"])
	return stats
	
func update_current_buzz(is_moving: bool, current_speed: float, effective_stats: Dictionary, delta: float) -> void:
	var fluff = effective_stats.get("fluffiness", 0.5)
	var fric = effective_stats.get("friction", 8.0)
	var wgt = effective_stats.get("weight", 70.0)
	var max_b = effective_stats.get("max_buzz", 10.0)
	var elasticity = effective_stats.get("elasticity", 70.0)
	var cushion = effective_stats.get("cushion", 0.5)
	if not is_moving:
		var buzz_decay = (elasticity + cushion) / fluff
		current_buzz = max(0.0, current_buzz - buzz_decay * delta)
	else:
		

		var buildup_rate = ((fluff * fric + wgt) * current_speed) / 500
		current_buzz = min(current_buzz + buildup_rate * delta, max_b)
