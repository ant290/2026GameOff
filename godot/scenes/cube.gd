@tool
extends MeshInstance3D

@export var rotation_speed := Vector3(0, -90, 0) # Degrees per second on X, Y, Z axes

func _process(delta: float) -> void:
	rotation_degrees += rotation_speed * delta
