extends Node
class_name CameraHandler

@export var character_handler: CharacterHandler
@onready var character_controller: CharacterController = get_parent() as CharacterController
@export var camera: Camera3D

var current_velocity: Vector3 = Vector3.ZERO
var previous_velocity: Vector3 = Vector3.ZERO

func _ready() -> void:
	if camera == null:
		print ("Failed to find camera")
		
func _physics_process(delta: float) -> void:
	if character_controller == null or character_handler == null or camera == null:
		return
		
	previous_velocity = current_velocity
	current_velocity = character_controller.horizontal_velocity
	
	var stats = character_handler.get_effective_stats()
	if stats.is_empty():
		print ("stats are empty camera handler")
		return
		
	var current_speed = current_velocity.length()

	var friction_factor = stats.get("friction", 0.5)
	
	var turn_rate = 0.0
	
	if current_speed > 0.5 and previous_velocity.length() > 0.5:
		var cross = previous_velocity.cross(current_velocity)
		var turn_magnitude = abs(cross.y)
		
		if turn_magnitude > 0.5:
			turn_rate = cross.y * 0.22
			
	turn_rate = clamp(turn_rate, -6.0, 6.0)	
	if (current_velocity - previous_velocity).length() > 5.0:
		turn_rate *= 0.3
		
	var target_roll = turn_rate / (2.0 + friction_factor * 0.2)
	
	camera.rotation.z = lerp(camera.rotation.z, target_roll, 0.15)
