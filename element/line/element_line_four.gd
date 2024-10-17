extends Node2D


func _ready() -> void:
	$ElementComponent.input_electricity(Electricity.Type.RED, ElementComponent.Direction.UP)
	await get_tree().create_timer(2).timeout
	$ElementComponent.vanish_electricity()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
