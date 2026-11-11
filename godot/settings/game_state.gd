extends Node

var score: int = 0

#region save data
func get_save_data() -> Dictionary:
	var save_data = {
		"score": score
	}

	return save_data

func load_data(save_data: Dictionary) -> void:
	if "score" in save_data:
		score = save_data["score"]

#endregion
