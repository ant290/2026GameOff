class_name CubeViewport
extends SubViewport

@export var cube_id : int = 0

@onready var cube: RotatorCube = $BitCube/Cube

signal cube_roll_finished(shouldFlowOver: bool, cube_id: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func rollCube() -> void:
	cube.rollCube()

func _on_cube_roll_finished(shouldFlowOver: bool) -> void:
	cube_roll_finished.emit(shouldFlowOver, cube_id)
