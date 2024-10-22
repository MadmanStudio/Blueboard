extends Node2D


@onready var element_comp: ElementComponent = $ElementComponent
@onready var point_light: PointLight2D = $PointLight

var lit: bool = false


func _ready() -> void:
	element_comp.core_filled.connect(on_core_filled)
	element_comp.core_cleared.connect(on_core_cleared)


func on_core_filled(type: Electricity.Type) -> void:
	point_light.show()
	lit = true
	
	
func on_core_cleared() -> void:
	point_light.hide()
	lit = false
