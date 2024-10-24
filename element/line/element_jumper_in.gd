extends Node2D


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
	pass
	
	
func activate(type: Electricity.Type) -> void:
	active = true
	core_type = type
	var jumper_out_list: Array = find_jumper_out_list()
	for jumper_out: Node2D in jumper_out_list:
		jumper_out.activate(type)
	
	
func disable() -> void:
	active = false
	var jumper_out_list: Array = find_jumper_out_list()
	for jumper_out: Node2D in jumper_out_list:
		jumper_out.disable()
	
	
	
func on_uninstalled(_element: Node2D) -> void:
	active = false
	var jumper_out_list: Array = find_jumper_out_list()
	for jumper_out: Node2D in jumper_out_list:
		jumper_out.disable()
			
			
func find_jumper_out_list() -> Array:
	var jumper_out_list: Array = []
	for i in level.matrix_size.x:
		for j in level.matrix_size.y:
			var element: Node2D = level.element_matrix[i][j]
			if element == null:
				continue
			var ec: ElementComponent = element.get_child(0)
			if ec.id == "jumper_out":
				jumper_out_list.append(element)
	return jumper_out_list
