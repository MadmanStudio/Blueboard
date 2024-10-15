extends Node


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			pass
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			pass
