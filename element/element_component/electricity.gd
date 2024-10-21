extends Line2D
class_name Electricity


enum Type
{
	RED, BLUE, YELLOW, PURPLE, ORANGE, GREEN, WHITE
}

const gray = Color("#c2c3c7")


func _ready() -> void:
	var shader_mat: ShaderMaterial = ShaderMaterial.new()
	var shader: Shader = Shader.new()
	shader.code = load("res://element/element_component/res/flow.gdshader").code
	shader_mat.shader = shader
	shader_mat.set_shader_parameter("direction", -1)
	material = shader_mat


func input(type: Type, switch_flowing_color: bool) -> void:
	default_color = Tables.ElectricityColorTable.get(type)
	enable_shader(default_color, switch_flowing_color)
	$AnimationPlayer.play("Input")


func output(type: Type, switch_flowing_color: bool) -> void:
	default_color = Tables.ElectricityColorTable.get(type)
	enable_shader(default_color, switch_flowing_color)
	$AnimationPlayer.play("Output")
	
	
func enable_shader(color: Color, switch_flowing_color: bool) -> void:
	if switch_flowing_color:
		material.set_shader_parameter("color1", gray)
		material.set_shader_parameter("color2", default_color)
	else:
		material.set_shader_parameter("color1", default_color)
		material.set_shader_parameter("color2", gray)
	
	
func vanish() -> void:
	$AnimationPlayer.play("RESET")
	
	
func retract() -> void:
	$AnimationPlayer.play_backwards("Output")
