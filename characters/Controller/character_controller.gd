extends CharacterBody3D
class_name CharacterController

@export var handler : CharacterHandler

@export var camera : Camera3D

var horizontal_velocity: Vector3 = Vector3.ZERO

func _physics_process(delta: float) -> void:
	if handler == null:
		return
	
	var stats = handler.get_effective_stats()
	if stats.is_empty():
		return

	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var is_moving = input_dir.length() > 0.1
	
	handler.update_current_buzz(is_moving, delta)
	
	var direction = Vector3.ZERO
	if camera:
		var cam_forward = -camera.global_transform.basis.z
		var cam_right = camera.global_transform.basis.x
		direction = (cam_forward * input_dir.y + cam_right * input_dir.x).normalized()
	else:
		direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	
	var max_speed = stats.get("effective_max_speed", 10.0)
	var accel = stats.get("effective_acceleration", 12.0)
	var decel = stats.get("effective_deceleration", 14.0)
	var current_buzz = stats.get("effective_buzz", 0.0)
	
	var stop_power = decel + (current_buzz * 0.6)
	
	if is_moving and direction != Vector3.ZERO:
		var target_velocity = direction * max_speed
		horizontal_velocity = horizontal_velocity.move_toward(target_velocity, accel * delta)
	else:
		horizontal_velocity = horizontal_velocity.move_toward(Vector3.ZERO, stop_power * delta)
		
	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z
	
	move_and_slide()
	
	horizontal_velocity.x = velocity.x
	horizontal_velocity.z = velocity.z
