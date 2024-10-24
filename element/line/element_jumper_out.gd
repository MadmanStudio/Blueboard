extends Node2D


@onready var element_component: ElementComponent = $ElementComponent
var level: Level
var active: bool = false


func _ready() -> void:
	level = get_meta("level")
	element_component.line_outputable_array = [true, false, false, false]
	element_component.installed.connect(on_installed)
	element_component.rotate_completed.connect(on_rotate_completed)
	
	
func on_installed() -> void:
	var jumper_in: Node2D = find_jumper_in()
	if jumper_in != null and jumper_in.active == true:
		element_component.fill_core(jumper_in.core_type)
		element_component.output_electricity_with_type(jumper_in.core_type, ElementComponent.Direction.UP)
	
	
func disable() -> void:
	active = false
	var output_dir: ElementComponent.Direction = get_output_dir()
	element_component.vanish_electricity()
	element_component.line_outputting_array[output_dir] = false
	level.propagate_electricity(self)
		
		
func activate(type: Electricity.Type) -> void:
	if active == true:
		return
	active = true
	var output_dir: ElementComponent.Direction = get_output_dir()
	element_component.fill_core(type)
	element_component.line_output_type_array[output_dir] = type
	element_component.output_electricity_with_type(type, output_dir)
	element_component.line_outputting_array[output_dir] = true
	level.propagate_electricity(self)
	
	
func get_output_dir() -> ElementComponent.Direction:
	var output_dir: ElementComponent.Direction
	for dir: ElementComponent.Direction in ElementComponent.Direction.values():
		if element_component.is_outputable(dir):
			output_dir = dir
			break
	return output_dir
	
	
func on_rotate_completed() -> void:
	var jumper_in: Node2D = find_jumper_in()
	if jumper_in != null:
		var output_dir: ElementComponent.Direction = get_output_dir()
		element_component.line_output_type_array[output_dir] = jumper_in.core_type
		level.propagate_electricity(self)
	
	
func find_jumper_in() -> Node2D:
	var jumper_in: Node2D
	for i in level.matrix_size.x:
		for j in level.matrix_size.y:
			var element: Node2D = level.element_matrix[i][j]
			if element == null:
				continue
			var ec: ElementComponent = element.get_child(0)
			if ec.id == "jumper_in":
				jumper_in = element
	return jumper_in
