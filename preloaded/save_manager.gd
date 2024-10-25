extends Node

const SAVE_PATH = "user://save_data.save"

var game_data = {
	"max_level": "1",
	"level_data": {
		"1": {
			"map_path": "res://level/maps/map_001.tmx",
			"next_level": "2",
			"element_dict": {
				"line_one": 2
			}
		},
		"2": {
			"map_path": "res://level/maps/map_002.tmx",
			"next_level": "3",
			"element_dict": {
				"line_one": 2
			}
		},
		"3": {
			"map_path": "res://level/maps/map_003.tmx",
			"next_level": "4",
			"element_dict": {
				"line_one": 2
			}
		},
		"4": {
			"map_path": "res://level/maps/map_004.tmx",
			"next_level": "1",
			"element_dict": {
				"line_one": 2
			}
		},
	}
}


func _ready():
	verify_save_path()


func verify_save_path():
	if not FileAccess.file_exists(SAVE_PATH):
		var new_file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
		if new_file:
			new_file.store_var(game_data)
			print("Success to save game. Path: ", new_file.get_path_absolute())
		
		
func save_game() -> void:
	collect_game_state()
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(game_data)
		print("Success to save game. Path: ", file.get_path_absolute())
		
		
func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		print("Save data not found")
		return false
	
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		game_data = file.get_var()
		apply_loaded_game_state()
		print("Success to load save data. Path: ", file.get_path_absolute())
		return true
	return false


func collect_game_state() -> void:
	var main: Main = get_tree().get_first_node_in_group("main")
	if main:
		game_data.max_level = main.max_level
		game_data.level_data = main.level_data


func apply_loaded_game_state() -> void:
	var main: Main = get_tree().get_first_node_in_group("main")
	if main:
		main.max_level = game_data.max_level
		main.level_data = game_data.level_data