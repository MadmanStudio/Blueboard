extends Node2D


func _ready() -> void:
	$ElementComponent.output_electricity(ElementComponent.Direction.DOWN)
