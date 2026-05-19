extends Resource
class_name CharacterStats

@export var character_name = "floppa"

@export_group("Stats")
@export var weight: float = 70.0
@export var fluffiness: float = 0.5
@export var friction: float = 8.0
@export var elasticity: float = 0.2
@export var cushion: float = 0.6

@export_group("stopping")
@export var buzz: float = 5.0

@export_group("limits")
@export var max_momentum: float = 0.2
@export var drag: float = 0.5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
