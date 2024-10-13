extends Node2D


func _ready() -> void:
	$ElementComponent.input_electricity(Electricity.Type.YELLOW, ElementComponent.Direction.DOWN)
