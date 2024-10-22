extends Node2D


@onready var element_component: ElementComponent = $ElementComponent
var level: Level
var active: bool = false


func _ready() -> void:
	element_component.line_outputable_array = [true, false, false, false]
	element_component.installed.connect(try_enable)
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
	
	
