extends Node


var ElectricityColorTable: Dictionary = {
	Electricity.Type.RED: Color.from_string("#ff004d", Color.BLACK),
	Electricity.Type.ORANGE: Color.from_string("#ffa300", Color.BLACK),
	Electricity.Type.YELLOW: Color.from_string("#ffec27", Color.BLACK),
	Electricity.Type.GREEN: Color.from_string("#00e436", Color.BLACK),
	Electricity.Type.BLUE: Color.from_string("#29adff", Color.BLACK),
	Electricity.Type.WHITE: Color.from_string("#fff1e8", Color.BLACK),
	Electricity.Type.PURPLE: Color.from_string("#7e2553", Color.BLACK)
}

var BlueboardTileAtlasCoordsTable: Dictionary = {
	"blueboard_point_01": Vector2i(11, 1),
	"blueboard_point_02": Vector2i(12, 1),
	"blueboard_point_03": Vector2i(13, 1),
	
	"blueboard_point_04": Vector2i(10, 2),
	"blueboard_point_05": Vector2i(11, 2),
	"blueboard_point_06": Vector2i(12, 2),
	"blueboard_point_07": Vector2i(13, 2),
	"blueboard_point_08": Vector2i(14, 2),
	
	"blueboard_point_09": Vector2i(10, 3),
	"blueboard_point_10": Vector2i(11, 3),
	"blueboard_point_11": Vector2i(12, 3),
	"blueboard_point_12": Vector2i(13, 3),
	"blueboard_point_13": Vector2i(14, 3),
	
	"blueboard_point_14": Vector2i(10, 4),
	"blueboard_point_15": Vector2i(11, 4),
	"blueboard_point_16": Vector2i(12, 4),
	"blueboard_point_17": Vector2i(13, 4),
	"blueboard_point_18": Vector2i(14, 4),
	
	"blueboard_point_19": Vector2i(11, 5),
	"blueboard_point_20": Vector2i(12, 5),
	"blueboard_point_21": Vector2i(13, 5),
	
	"blueboard_01": Vector2i(6, 1),
	"blueboard_02": Vector2i(7, 1),
	"blueboard_03": Vector2i(8, 1),
	
	"blueboard_04": Vector2i(5, 2),
	"blueboard_05": Vector2i(6, 2),
	"blueboard_06": Vector2i(7, 2),
	"blueboard_07": Vector2i(8, 2),
	"blueboard_08": Vector2i(9, 2),
	
	"blueboard_09": Vector2i(5, 3),
	"blueboard_10": Vector2i(6, 3),
	"blueboard_11": Vector2i(7, 3),
	"blueboard_12": Vector2i(8, 3),
	"blueboard_13": Vector2i(9, 3),
	
	"blueboard_14": Vector2i(5, 4),
	"blueboard_15": Vector2i(6, 4),
	"blueboard_16": Vector2i(7, 4),
	"blueboard_17": Vector2i(8, 4),
	"blueboard_18": Vector2i(9, 4),
	
	"blueboard_19": Vector2i(6, 5),
	"blueboard_20": Vector2i(7, 5),
	"blueboard_21": Vector2i(8, 5)
}

var ElementPathTable: Dictionary = {
	"G_red": "res://element/generator/element_G_red.tscn",
	"G_blue": "res://element/generator/element_G_blue.tscn",
	"G_yellow": "res://element/generator/element_G_yellow.tscn",
	"L_purple": "res://element/leacher/element_L_purple.tscn",
	"L_green": "res://element/leacher/element_L_green.tscn",
	"L_orange": "res://element/leacher/element_L_orange.tscn",
	"I_purple": "res://element/intermixer/element_I_purple.tscn",
	"I_green": "res://element/intermixer/element_I_green.tscn",
	"I_orange": "res://element/intermixer/element_I_orange.tscn",
	"hinderer": "res://element/hinderer/element_H.tscn",
	"jumper_in": "res://element/jumper/element_jumper_in.tscn",
	"jumper_out": "res://element/jumper/element_jumper_out.tscn",
	"line_one": "res://element/line/element_L_yellow.tscn",
	"line_two": "res://element/line/element_L_yellow.tscn",
	"line_three": "res://element/line/element_L_yellow.tscn",
	"line_four": "res://element/line/element_L_yellow.tscn"
}
