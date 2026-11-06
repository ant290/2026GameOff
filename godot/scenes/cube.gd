class_name RotatorCube
extends MeshInstance3D

signal roll_finished(shouldFlowOver : bool)

var _queued_rolls := 0
var _is_rolling := false

var shouldFlowOver := false

func rollCube() -> void:
	_queued_rolls += 1
	if _is_rolling:
		return

	_is_rolling = true
	while _queued_rolls > 0:
		_queued_rolls -= 1
		var tween := create_tween()
		tween.tween_property(self, "rotation_degrees", Vector3(0, -90, 0), 0.2).as_relative()
		await tween.finished
		roll_finished.emit(shouldFlowOver)
		shouldFlowOver = !shouldFlowOver
	_is_rolling = false
