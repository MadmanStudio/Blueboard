extends CanvasLayer


class GuideStep:
	var guide_text: String
	var target_position: Vector2
	var circle_radius: float
	
var current_step: int = 0
var is_guiding: bool = true
var guide_steps: Array[GuideStep] = [
	
]


func _ready() -> void:
	Globals.allow_operate = false


func _on_color_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		var tp: Vector2 = guide_steps[current_step].target_position
		var cr: float = guide_steps[current_step].circle_radius
		$Mask.material.set_shader_parameter("center", tp)
		$Mask.material.set_shader_parameter("center", tp)
