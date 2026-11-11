## Script that manages saving games.
class_name SaveGame extends Node

const ENABLED = true
const ENCRYPTION_KEY = "godotrules"
const SAVE_GAME_TEMPLATE = "savegame.save"
const SAVE_GROUP_NAME = "Persist"
const NODE_DATA = "node_data"

static func delete_save() -> void:
	
	if not ENABLED:
		return
		
	DirAccess.remove_absolute("user://" + SAVE_GAME_TEMPLATE)

static func has_save() -> bool:
	return FileAccess.file_exists("user://" + SAVE_GAME_TEMPLATE)

static func save_game():
	
	if not ENABLED:
		return
	
	print("Saving game to user://" + SAVE_GAME_TEMPLATE)
	
	var save_file = null
	
	if OS.is_debug_build():
		save_file = FileAccess.open("user://" + SAVE_GAME_TEMPLATE, FileAccess.WRITE)
	else:
		save_file = FileAccess.open_encrypted_with_pass("user://" + SAVE_GAME_TEMPLATE, FileAccess.WRITE, ENCRYPTION_KEY)
		
	var save_data = {}

	save_data["game_state"] = GameState.get_save_data()
		
	# Store the save dictionary as a new line in the save file.
	save_file.store_line(JSON.stringify(save_data))

static func load_game() -> void:
	
	if not ENABLED:
		return

	if not has_save():
		print("No save game found. Skipped loading!")
		return
	
	print("Load game from user://" + SAVE_GAME_TEMPLATE)

	# Load the file line by line and process that dictionary to restore
	# the classes and their properties.
	var save_file = null
	
	if OS.is_debug_build():
		save_file = FileAccess.open("user://" + SAVE_GAME_TEMPLATE, FileAccess.READ)
	else:
		save_file = FileAccess.open_encrypted_with_pass("user://" + SAVE_GAME_TEMPLATE, FileAccess.READ, ENCRYPTION_KEY)
		
	while save_file.get_position() < save_file.get_length():
		# Get the saved dictionary from the next line in the save file
		var json_helper = JSON.new()
		var parse_result = json_helper.parse(save_file.get_line())
		
		if not parse_result == OK:
			print("Error parsing save file: " + json_helper.get_error_message())
			continue
		
		var data = json_helper.data

		for key in data.keys():
			match key:
				"game_state":
					GameState.load_data(data[key])
				_:
					print("Unknown save data key: " + key)
