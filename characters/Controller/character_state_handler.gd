extends Node
class_name CharacterStateHandler

@export var character_handler: CharacterHandler
@onready var character_controller: CharacterController = get_parent() as CharacterController

var current_squish_offset: float = 0.0
var is_in_landing_recovery: bool = false
var was_in_air: bool = true
var recovery_progress: float = 0.0

enum State { IDLE, SQUASHING, PAUSED, RECOVERING }
var current_state: State = State.IDLE

var squish_timer: float = 0.0
var squish_target: float = 0.0
var base_camera_y: float = 0.6
var previous_vertical_speed = 0.0
var pause_duration: float = 0.0

func _ready() -> void:
	if character_controller and character_controller.camera:
		base_camera_y = character_controller.camera.position.y

func _physics_process(delta: float) -> void:
	if character_controller == null or character_handler == null:
		return
	_handle_landing_detection(delta)
	_update_squish_state(delta)
	
func _handle_landing_detection(delta: float) -> void:
	var is_on_floor = character_controller.is_on_floor()
	previous_vertical_speed = character_controller.pre_move_velocity.y
	
	if was_in_air and is_on_floor and previous_vertical_speed <= -10.0:
		_trigger_landing_impact(previous_vertical_speed)
		
	was_in_air = not is_on_floor
	
func _trigger_landing_impact(vertical_speed: float) -> void:
	if character_handler == null:
		return
		
	var stats = character_handler.get_effective_stats()
	if stats.is_empty():
		return
		
	var weight = stats.get("weight")
	var cushion = stats.get("cushion")
	
	var landing_force = -vertical_speed * weight
	var squish_depth = landing_force * cushion * 0.008
	
	squish_target = max(-0.55, -squish_depth)
	
	var is_hard_landing = max (0.55, -squish_depth)
	
	current_squish_offset = 0.0
	current_state = State.SQUASHING
	pause_duration = 0.08 + (landing_force * cushion * 0.0008)
	squish_timer = 0.0
	is_in_landing_recovery = true

func _update_squish_state(delta: float) -> void:
	if not is_in_landing_recovery:
		return
	
	squish_timer += delta
	
	match current_state:
		State.SQUASHING:
			current_squish_offset = lerp(current_squish_offset, squish_target, 0.35)
			
			if abs(current_squish_offset - squish_target) < 0.1:
				if abs(squish_target) >= 0.45:
					current_state = State.PAUSED
					squish_timer = 0.0
				else:
					current_state = State.RECOVERING
					squish_timer = 0.0
		
		State.PAUSED:
			if squish_timer >= pause_duration:
				current_state = State.RECOVERING
				squish_timer = 0.0
		
		State.RECOVERING:
			var stats = character_handler.get_effective_stats()
			var elasticity = stats.get("elasticity")
			var cushion = stats.get("cushion")

			var recovery_speed = 4.0 + (elasticity * 12) - (cushion * 3.0)
			
			var overshoot_amount = 0.0
			if recovery_speed > 6.0:
				overshoot_amount = 0.08 * elasticity
				
			var target = overshoot_amount if overshoot_amount > 0.0 else 0.0
			
			current_squish_offset = lerp(current_squish_offset, target, recovery_speed * delta)
			
			if abs(current_squish_offset - target) < 0.015:
				current_squish_offset =  0.0
				is_in_landing_recovery = false
				current_state = State.IDLE
