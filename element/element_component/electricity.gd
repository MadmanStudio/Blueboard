extends Line2D
class_name Electricity


enum Type
{
	RED, BLUE, YELLOW, PURPLE, ORANGE, GREEN, WHITE
}

const gray = Color("#c2c3c7")

var current_color1: Color
var current_color2: Color


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
		current_color1 = color
		current_color2 = gray
		var color_temp: Color = current_color1
		current_color1 = current_color2
		current_color2 = color_temp
		material.set_shader_parameter("color1", current_color1)
		material.set_shader_parameter("color2", current_color2)
	else:
		current_color1 = color
		current_color2 = gray
		material.set_shader_parameter("color1", current_color1)
		material.set_shader_parameter("color2", current_color2)
	
	
func vanish() -> void:
	$AnimationPlayer.play("RESET")
	
