extends Node2D


signal on_activated(type: Electricity.Type)
signal on_disabled


@onready var element_component: ElementComponent = $ElementComponent
var active: bool = false
var core_type: Electricity.Type
var level: Level


func _ready() -> void:
	level = get_meta("level")
	element_component.line_inputable_array = [true, false, false, false]
	element_component.core_filled.connect(activate)
	element_component.core_cleared.connect(disable)
	element_component.installed.connect(on_installed)
	element_component.uninstalled.connect(on_uninstalled)
	
	
func on_installed() -> void:
	for i in level.matrix_size.x:
		for j in level.matrix_size.y:
			var element: Node2D = level.element_matrix[i][j]
			if element == null:
				continue
			var ec: ElementComponent = element.get_child(0)
			if ec.id != "jumper_out":
				continue
			element.bind_in_signal(self)
	var input_dir: ElementComponent.Direction
	for dir in ElementComponent.Direction.values():
		if element_component.is_inputable(dir):
			input_dir = dir
			break
	if element_component.is_inputting(input_dir):
		activate(element_component.get_allow_input_type(input_dir) as Electricity.Type)
	
	
func activate(type: Electricity.Type) -> void:
	core_type = type
	active = true
	on_activated.emit(type)
	
	
func disable() -> void:
	active = false
	on_disabled.emit()
	
	
func on_uninstalled() -> void:
	active = false
	for i in level.matrix_size.x:
		for j in level.matrix_size.y:
			var element: Node2D = level.element_matrix[i][j]
			if element == null:
				continue
			var ec: ElementComponent = element.get_child(0)
			if ec.id != "jumper_out":
				continue
			element.unbind_in_signal(self)
