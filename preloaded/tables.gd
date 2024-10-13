extends Node


var ElectricityColorTable: Dictionary = {
	Electricity.Type.RED: Color.from_string("#ff004d", Color.BLACK),
	Electricity.Type.ORANGE: Color.from_string("#ffa300", Color.BLACK),
	Electricity.Type.YELLOW: Color.from_string("#ffec27", Color.BLACK),
	Electricity.Type.GREEN: Color.from_string("#00e436", Color.BLACK),
	Electricity.Type.BLUE: Color.from_string("#29adff", Color.BLACK),
	Electricity.Type.WHITE: Color.from_string("#fff1e8", Color.BLACK)
}
