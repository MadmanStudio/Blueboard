extends Node


const ElectricityColorTable: Dictionary = {
	Electricity.Type.RED: Color("#ff004d", 1.0),
	Electricity.Type.ORANGE: Color("#ffa300", 1.0),
	Electricity.Type.YELLOW: Color("#ffec27", 1.0),
	Electricity.Type.GREEN: Color("#00e436", 1.0),
	Electricity.Type.BLUE: Color("#29adff", 1.0),
	Electricity.Type.WHITE: Color("#fff1e8", 1.0),
	Electricity.Type.PURPLE: Color("#7e2553", 1.0)
}

const BlueboardTileAtlasCoordsTable: Dictionary = {
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

const ElementPathTable: Dictionary = {
	"G_red": "res://element/generator/element_G_red.tscn",
	"G_blue": "res://element/generator/element_G_blue.tscn",
	"G_yellow": "res://element/generator/element_G_yellow.tscn",
	"L_purple": "res://element/leacher/element_L_purple.tscn",
	"L_green": "res://element/leacher/element_L_green.tscn",
	"L_orange": "res://element/leacher/element_L_orange.tscn",
	"I_purple": "res://element/intermixer/element_I_purple.tscn",
	"I_green": "res://element/intermixer/element_I_green.tscn",
	"I_orange": "res://element/intermixer/element_I_orange.tscn",
	"T_y2b": "res://element/transformer/element_T_yellow2blue.tscn",
	"T_y2r": "res://element/transformer/element_T_yellow2red.tscn",
	"T_b2r": "res://element/transformer/element_T_blue2red.tscn",
	"T_b2y": "res://element/transformer/element_T_blue2yellow.tscn",
	"T_r2b": "res://element/transformer/element_T_red2blue.tscn",
	"T_r2y": "res://element/transformer/element_T_red2yellow.tscn",
	"hinderer": "res://element/hinderer/element_H.tscn",
	"jumper_in": "res://element/line/element_jumper_in.tscn",
	"jumper_out": "res://element/line/element_jumper_out.tscn",
	"line_one": "res://element/line/element_line_one.tscn",
	"line_two": "res://element/line/element_line_two.tscn",
	"line_three": "res://element/line/element_line_three.tscn",
	"line_four": "res://element/line/element_line_four.tscn",
	"light_purple": "res://element/light/element_light_purple.tscn",
	"light_blue": "res://element/light/element_light_blue.tscn",
	"light_red": "res://element/light/element_light_red.tscn",
	"light_green": "res://element/light/element_light_green.tscn",
	"light_orange": "res://element/light/element_light_orange.tscn",
	"light_yellow": "res://element/light/element_light_yellow.tscn",
}

const ElementIconTable: Dictionary = {
	"G_red": "res://element/generator/res/element_G_red.atlastex",
	"G_blue": "res://element/generator/res/element_G_blue.atlastex",
	"G_yellow": "res://element/generator/res/element_G_yellow.atlastex",
	"L_purple": "res://element/leacher/res/element_L_purple.atlastex",
	"L_green": "res://element/leacher/res/element_L_green.atlastex",
	"L_orange": "res://element/leacher/res/element_L_orange.atlastex",
	"I_purple": "res://element/intermixer/res/element_I_purple.atlastex",
	"I_green": "res://element/intermixer/res/element_I_green.atlastex",
	"I_orange": "res://element/intermixer/res/element_I_orange.atlastex",
	"T_y2b": "res://element/transformer/res/element_T_yellow2blue.atlastex",
	"T_y2r": "res://element/transformer/res/element_T_yellow2red.atlastex",
	"T_b2r": "res://element/transformer/res/element_T_blue2red.atlastex",
	"T_b2y": "res://element/transformer/res/element_T_blue2yellow.atlastex",
	"T_r2b": "res://element/transformer/res/element_T_red2blue.atlastex",
	"T_r2y": "res://element/transformer/res/element_T_red2yellow.atlastex",
	"hinderer": "res://element/hinderer/res/element_H.atlastex",
	"jumper_in": "res://element/line/res/element_jumper_in.atlastex",
	"jumper_out": "res://element/line/res/element_jumper_out.atlastex",
	"line_one": "res://element/line/res/element_line_one.atlastex",
	"line_two": "res://element/line/res/element_line_two.atlastex",
	"line_three": "res://element/line/res/element_line_three.atlastex",
	"line_four": "res://element/line/res/element_line_four.atlastex",
	"light_purple": "res://element/light/res/element_light_purple.atlastex",
	"light_blue": "res://element/light/res/element_light_blue.atlastex",
	"light_red": "res://element/light/res/element_light_red.atlastex",
	"light_green": "res://element/light/res/element_light_green.atlastex",
	"light_orange": "res://element/light/res/element_light_orange.atlastex",
	"light_yellow": "res://element/light/res/element_light_yellow.atlastex",
}
