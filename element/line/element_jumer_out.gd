extends Node2D


@onready var element_component: ElementComponent = $ElementComponent
var level: Level
var active: bool = false
var output_dir: ElementComponent.Direction


func _ready() -> void:
	level = get_meta("level")
	element_component.line_outputable_array = [true, false, false, false]
	element_component.installed.connect(on_installed)
	
	
func on_installed() -> void:
	for i in level.matrix_size.x:
		for j in level.matrix_size.y:
			var element: Node2D = level.element_matrix[i][j]
			if element == null:
				continue
			var ec: ElementComponent = element.get_child(0)
			if ec.id != "jumper_in":
				continue
			bind_in_signal(element)
			if element.active == true:
				active = true
				element_component.fill_core(element.core_type)
				element_component.output_electricity(output_dir)
				on_in_activated(element.core_type)
	
	
func bind_in_signal(element_in: Node2D) -> void:
	element_in.on_activated.connect(on_in_activated)
	element_in.on_disabled.connect(on_in_disabled)
	
	
func unbind_in_signal(element_in: Node2D) -> void:
	element_in.on_activated.disconnect(on_in_activated)
	element_in.on_disabled.disconnect(on_in_disabled)
	
	
func on_in_disabled() -> void:
	active = false
	var faced_element: Node2D = get_faced_element()
	element_component.vanish_electricity()
	element_component.line_outputting_array[output_dir] = false
	if faced_element != null:
		level.propagate_electricity(faced_element)
		
		
func on_in_activated(type: Electricity.Type) -> void:
	active = true
	var faced_element: Node2D = get_faced_element()
	element_component.fill_core(type)
	element_component.output_electricity_with_type(type, output_dir)
	element_component.line_outputting_array[output_dir] = true
	if faced_element != null:
		level.propagate_electricity(faced_element)
	
	
func get_faced_element() -> Node2D:
	for dir in ElementComponent.Direction.values():
		if element_component.is_outputable(dir):
			output_dir = dir
			break
	var faced_element_coord: Vector2i = element_component.installed_coord + level.Dirs[output_dir]
	var faced_element: Node2D = level.element_matrix[faced_element_coord.x][faced_element_coord.y]
	return faced_element
