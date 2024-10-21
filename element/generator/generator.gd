extends Node2D


func _ready() -> void:
	$ElementComponent/Control/Surface.hide()
	$ElementComponent.output_electricity(ElementComponent.Direction.DOWN)
