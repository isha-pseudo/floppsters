extends Node
class_name CharacterStateHandler

@export var character_handler: CharacterHandler
@export var character_controller: CharacterController

var current_squish_offset: float = 0.0
var is_in_landing_recovery: bool = false
var recovery_progress: float = 0.0

enum State { IDLE, SQUASHING, PAUSED, RECOVERING }
var current_state: State = State.IDLE

var squish_timer: float = 0.0
var squish_target: float = 0.0
var base_camera_y: float = 0.6

func _physics_process(delta: float) -> void:
	if character_controller == null or character_handler == null:
		return
	_handle_landing_detection(delta)
	
func _handle_landing_detection(delta: float) -> void:
	pass
	
