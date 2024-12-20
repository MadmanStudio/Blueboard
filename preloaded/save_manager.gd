extends Node

const SAVE_PATH = "user://save_data.save"

var game_data = {
	"max_level": "1",
	"level_data": {
		"1": {
			"map_path": "res://level/maps/map_001.tmx",
			"next_level": "2",
			"element_dict": {
				"line_one": 4
			}
		},
		"2": {
			"map_path": "res://level/maps/map_002.tmx",
			"next_level": "3",
			"element_dict": {
				"line_one": 1,
				"line_two": 2
			}
		},
		"3": {
			"map_path": "res://level/maps/map_003.tmx",
			"next_level": "4",
			"element_dict": {
				"jumper_out": 1,
				"jumper_in": 1,
			}
		},
		"4": {
			"map_path": "res://level/maps/map_004.tmx",
			"next_level": "5",
			"element_dict": {
				"G_blue": 1,
				"jumper_out": 2,
				"jumper_in": 1,
			}
		},
		"5": {
			"map_path": "res://level/maps/map_005.tmx",
			"next_level": "6",
			"element_dict": {
				"line_one": 5,
				"line_two": 2
			}
		},
		"6": {
			"map_path": "res://level/maps/map_006.tmx",
			"next_level": "7",
			"element_dict": {
				"line_one": 3,
				"line_two": 6,
				"jumper_out": 1,
				"jumper_in": 1,
			}
		},
		"7": {
			"map_path": "res://level/maps/map_007.tmx",
			"next_level": "8",
			"element_dict": {
				"line_one": 8,
				"line_two": 2
			}
		},
		"8": {
			"map_path": "res://level/maps/map_008.tmx",
			"next_level": "9",
			"element_dict": {
				"line_one": 5,
				"line_two": 3,
				"line_three": 1
			}
		},
		"9": {
			"map_path": "res://level/maps/map_009.tmx",
			"next_level": "10",
			"element_dict": {
				"G_red": 1,
				"line_one": 9,
				"line_two": 9,
				"line_three": 1,
				"jumper_out": 1,
			}
		},
		"10": {
			"map_path": "res://level/maps/map_010.tmx",
			"next_level": "11",
			"element_dict": {
				"line_one": 21,
				"line_three": 1,
				"line_four": 5,
				"jumper_out": 1,
				"jumper_in": 1,
			}
		},
		"11": {
			"map_path": "res://level/maps/map_011.tmx",
			"next_level": "12",
			"element_dict": {
				"G_red": 1,
				"T_r&y": 1,
				"T_b&y": 1,
				"line_one": 8,
				"line_two": 8,
				"line_three": 2,
				"jumper_out": 1,
				"jumper_in": 1,
			}
		},
		"12": {
			"map_path": "res://level/maps/map_012.tmx",
			"next_level": "13",
			"element_dict": {
				"T_r&b": 1,
				"L_green": 1,
				"I_green": 1,
				"line_one": 10,
				"line_two": 6,
				"jumper_out": 3
			}
		},
		"13": {
			"map_path": "res://level/maps/map_013.tmx",
			"next_level": "14",
			"element_dict": {
				"T_r&b": 1,
				"T_r&y": 1,
				"T_b&y": 1,
				"line_one": 8,
				"line_two": 2,
				"jumper_out": 3,
				"jumper_in": 1,
			}
		},
		"14": {
			"map_path": "res://level/maps/map_014.tmx",
			"next_level": "15",
			"element_dict": {
				"T_r&b": 1,
				"T_r&y": 2,
				"I_green": 1,
				"I_purple": 1,
				"L_purple": 1,
				"line_one": 21,
				"line_two": 8,
				"line_three": 3,
				"jumper_out": 3,
				"jumper_in": 1
			}
		},
		"15": {
			"map_path": "res://level/maps/map_015.tmx",
			"next_level": "16",
			"element_dict": {
				"T_b&y": 2,
				"T_r&y": 2,
				"T_r&b": 1,
				"I_orange": 1,
				"I_green": 1,
				"L_green": 1,
				"line_one": 17,
				"line_two": 19,
				"line_three": 7,
				"jumper_out": 2,
				"jumper_in": 1,
			}
		},
		"16": {
			"map_path": "res://level/maps/map_016.tmx",
			"next_level": "1",
			"element_dict": {
				"T_b&y": 2,
				"T_r&y": 3,
				"T_r&b": 2,
				"I_orange": 1,
				"line_one": 7,
				"line_two": 14,
				"line_three": 3,
				"jumper_out": 3,
				"jumper_in": 1,
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
