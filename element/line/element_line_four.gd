extends Node2D


func _ready() -> void:
	$ElementComponent.input_electricity(Electricity.Type.RED, ElementComponent.Direction.UP)
