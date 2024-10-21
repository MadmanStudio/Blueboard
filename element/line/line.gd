extends Node2D


var element_comp: ElementComponent


func _ready() -> void:
	element_comp = get_child(0)
	element_comp.core_filled.connect(on_core_filled)
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
