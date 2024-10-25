extends Node2D


@onready var element_component: ElementComponent = $ElementComponent

var level: Level


func _ready() -> void:
	level = get_meta("level")
	element_component.any_surrounding_element_updated.connect(check)
	element_component.core_filled.connect(on_core_filled)


func on_core_filled(type: Electricity.Type) -> void:
	var all_input: bool = true
	if not element_component.is_inputting(ElementComponent.Direction.LEFT):
		all_input = false
	if not element_component.is_inputting(ElementComponent.Direction.RIGHT):
		all_input = false
	if all_input:
		element_component.output_electricity(ElementComponent.Direction.DOWN)


func check() -> void:
	var all_input: bool = true
	if not element_component.is_inputting(ElementComponent.Direction.LEFT):
		all_input = false
	if not element_component.is_inputting(ElementComponent.Direction.RIGHT):
		all_input = false
	if not all_input:
		element_component.vanish_electricity()
	else:
		element_component.output_electricity(ElementComponent.Direction.DOWN)
	level.propagate_electricity(self)
	level.propagate_electricity(self)
