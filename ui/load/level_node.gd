@tool
class_name LevelNode
extends Button


signal clicked(level_node: LevelNode)


var level_name: String = "1":
	set(new_value):
		level_name = new_value
		$LevelName.text = new_value
var next_level: String
var map_path: String
var element_dict: Dictionary

var selected: bool = false


func select() -> void:
	selected = true
	$Selected.show()


func unselect() -> void:
	selected = false
	$Selected.hide()


func hover() -> void:
	$Selected.show()
	
	
func unhover() -> void:
	if not selected:
		$Selected.hide()


func _on_button_down() -> void:
	clicked.emit(self)


func _on_mouse_entered() -> void:
	hover()


func _on_mouse_exited() -> void:
	unhover()
