extends CharacterBody3D
class_name CharacterController

@export var handler : CharacterHandler

@export var camera : Camera3D

## camera settings

@export var mouse_sensitivity: float = 0.003
@export var max_pitch: float = 89.0   # Prevents looking too far up/down

var camera_pitch: float = 0.0

var horizontal_velocity: Vector3 = Vector3.ZERO

var coyote_timer: float = 0.0

var pre_move_velocity: Vector3 = Vector3.ZERO

## raycast

@onready var interact_raycast: RayCast3D = $Camera3D/InteractRaycast

@onready var interact_prompt: Label = $InteractPrompt

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	if handler == null:
		print ("no handler")
		return
	
	var stats = handler.get_effective_stats()
	if stats.is_empty():
		return
		
	if not is_on_floor():
		velocity.y -= 20.0 * delta
		
	var weight = stats.get("weight", 70.0)
	var elasticity = stats.get("elasticity", 0.2)
	var jump_velocity = 8.0 * (elasticity / 0.2) * (70.0 / weight)

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var is_moving = input_dir.length() > 0.1
	var current_speed = horizontal_velocity.length()
	handler.update_current_buzz(is_moving, current_speed, stats, delta)
	
	var direction = Vector3.ZERO
	if camera:
		var cam_forward = -camera.global_transform.basis.z
		var cam_right = camera.global_transform.basis.x
		direction = (cam_forward * -input_dir.y + cam_right * input_dir.x).normalized()
	else:
		direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	
	var max_speed = stats.get("effective_max_speed", 10.0)
	var accel = stats.get("effective_acceleration", 12.0)
	var decel = stats.get("effective_deceleration", 14.0)
	
	var current_buzz = stats.get("effective_buzz", 0.0)
	var friction = stats.get("friction", 0.0)
	
	var stop_power = decel + ((friction * 0.8) + (current_buzz * 0.6))
	
	if is_moving and direction != Vector3.ZERO:
		var target_velocity = direction * max_speed
		var turn_resist = stats["inertial_resistance"]
		var effective_accel = accel / (1.0 + turn_resist * 0.08)
		horizontal_velocity = horizontal_velocity.move_toward(target_velocity, effective_accel * delta)
		var alignment = horizontal_velocity.normalized().dot(direction)
	else:
		if is_on_floor():
			horizontal_velocity = horizontal_velocity.move_toward(Vector3.ZERO, stop_power * delta)
		else:
			horizontal_velocity = horizontal_velocity.move_toward(Vector3.ZERO, delta)
	if not is_on_floor():
		coyote_timer = max(0.0, coyote_timer - delta)
	else:
		coyote_timer = 0.4
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_timer > 0):
		velocity.y = jump_velocity
		coyote_timer = 0.0
	
	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z
	
	pre_move_velocity = velocity
	
	move_and_slide()
	
	horizontal_velocity.x = velocity.x
	horizontal_velocity.z = velocity.z
	
	if interact_raycast.is_colliding():
		var hit = interact_raycast.get_collider()
		if hit and hit.has_method("interact"):
			interact_prompt.visible = true
		else:
			interact_prompt.visible = false
	else:
		interact_prompt.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		return
		
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera_pitch -= event.relative.y * mouse_sensitivity
		camera_pitch = clamp(camera_pitch, deg_to_rad(-max_pitch), deg_to_rad(max_pitch))
		if camera:
			camera.rotation.x = camera_pitch
	if event.is_action_pressed("interact"):
		interact()
			
func interact() -> void:
	if interact_raycast.is_colliding():
		var hit = interact_raycast.get_collider()
		if hit.has_method("interact"):
			hit.interact(self)
