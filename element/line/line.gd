extends Node2D


@onready var element_comp: ElementComponent = $ElementComponent

var level: Level


func _ready() -> void:
	level = get_meta("level")
	element_comp.core_filled.connect(on_core_filled)
	element_comp.any_surrounding_element_updated.connect(check)
	# 莫名其妙的BUG
	# 从 @export 变量中配置的值不生效
	# 只好这样做了
	if element_comp.id == "line_one":
		element_comp.line_inputable_array = [false, true, false, true]
		element_comp.line_outputable_array = [false, true, false, true]
	if element_comp.id == "line_two":
		element_comp.line_inputable_array = [true, true, false, false]
		element_comp.line_outputable_array = [true, true, false, false]
	if element_comp.id == "line_three":
		element_comp.line_inputable_array = [true, true, false, true]
		element_comp.line_outputable_array = [true, true, false, true]


func on_core_filled(type: Electricity.Type) -> void:
	element_comp.line_output_type_array = [type, type, type, type]


func check() -> void:
	level.propagate_electricity(self)
