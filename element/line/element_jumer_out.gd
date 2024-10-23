extends Node2D


@onready var element_component: ElementComponent = $ElementComponent
var level: Level
var active: bool = false
var output_dir: ElementComponent.Direction


func _ready() -> void:
	element_component.line_outputable_array = [true, false, false, false]
	element_component.installed.connect(try_enable)
	element_component.core_filled.connect(on_core_filled)
	element_component.core_cleared.connect(on_core_cleared)
	level = get_meta("level")
	
	
func try_enable() -> void:
	for i in level.matrix_size.x:
		for j in level.matrix_size.y:
			var element: Node2D = level.element_matrix[i][j]
			if element == null:
				continue
			var ec: ElementComponent = element.get_child(0)
			if ec.id != "jumper_in":
				continue
			if element.active == true:
				active = true
				element_component.fill_core_and_output(element.core_type)
	
	
func on_core_cleared() -> void:
	var faced_element: Node2D = get_faced_element()
	element_component.line_outputting_array[output_dir] = false
	if faced_element != null:
		level.propagate_electricity(faced_element)
		
		
func on_core_filled(type: Electricity.Type) -> void:
	var faced_element: Node2D = get_faced_element()
	element_component.line_outputting_array[output_dir] = true
	if faced_element != null:
		level.propagate_electricity(faced_element)
	
	
func get_faced_element() -> Node2D:
	for dir in ElementComponent.Direction.values():
		if element_component.line_outputable_array[dir]:
			output_dir = dir
			break
	var faced_element_coord: Vector2i = element_component.installed_coord + level.Dirs[output_dir]
	var faced_element: Node2D = level.element_matrix[faced_element_coord.x][faced_element_coord.y]
	return faced_element
