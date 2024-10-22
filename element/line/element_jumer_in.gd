extends Node2D


@onready var element_component: ElementComponent = $ElementComponent
var level: Level
var active: bool = false
var core_type: Electricity.Type


func _ready() -> void:
	element_component.line_inputable_array = [true, false, false, false]
	element_component.core_filled.connect(enable_out)
	element_component.core_cleared.connect(disable_out)
	element_component.uninstalled.connect(disable_out)
	level = get_meta("level")
	
	
func enable_out(type: Electricity.Type) -> void:
	active = true
	core_type = type
	var out_element: Node2D = find_out_element()
	if out_element != null:
		out_element.active = true
		out_element.get_child(0).fill_core_and_output(type)
	
	
func disable_out() -> void:
	active = false
	var out_element: Node2D = find_out_element()
	if out_element != null:
		out_element.active = false
		out_element.get_child(0).vanish_electricity()
	
	
func find_out_element() -> Node2D:
	var out_element: Node2D
	for i in level.matrix_size.x:
		for j in level.matrix_size.y:
			var element: Node2D = level.element_matrix[i][j]
			if element == null:
				continue
			var ec: ElementComponent = element.get_child(0)
			if ec.id == "jumper_out":
				out_element = element
				break
	return out_element
