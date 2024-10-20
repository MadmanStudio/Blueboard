@tool
extends Control
class_name ElementComponent


var id: String
var detachabled: bool = false
var current_deg: int = 0

enum Direction
{
	UP, RIGHT, DOWN, LEFT
}

# 每个电路允许输入的电力类型
# 如果电路不支持该电力类型，则无法在该电路上输入或输出电力
# 对于一个电路，只有二种情况：允许全部类型（ALL），允许单一类型
# 这个枚举的类型定义位置十分关键，前面的类型顺序必须时刻与 Electricity.Type 保持同步
enum AllowInputType
{
	RED, BLUE, YELLOW, PURPLE, ORANGE, GREEN, WHITE, ALL
}

@export var surface_texture: Texture2D:
	set(new_texture):
		surface_texture = new_texture
		$Control/Surface.texture = new_texture

# 当前元件的四个电路的数据，在元件被顺时针旋转后进行滚动
# 按照下标依次为：上，右，下，左
@export var line_disabled_array: Array[bool] = [false, false, false, false]
@export var line_inputable_array: Array[bool] = [true, true, true, true]
@export var line_outputable_array: Array[bool] = [true, true, true, true]
@export var line_allow_input_type_array: Array[AllowInputType] = [
	AllowInputType.ALL, AllowInputType.ALL,
	AllowInputType.ALL, AllowInputType.ALL
]
@export var line_output_type_array: Array[Electricity.Type] = [
	Electricity.Type.RED, Electricity.Type.RED,
	Electricity.Type.RED, Electricity.Type.RED
]
@export var rotatable: bool = false

@onready var e1: Electricity = $Electricity1
@onready var e2: Electricity = $Electricity2
@onready var e3: Electricity = $Electricity3
@onready var e4: Electricity = $Electricity4
@onready var electricity_array: Array[Electricity] = [e1, e2, e3, e4]
var line_outputting_array: Array[bool] = [false, false, false, false]
var line_inputting_array: Array[bool] = [false, false, false, false]
	
	
func fill_core(electricity_type: Electricity.Type) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($Control/Core, "color", Tables.ElectricityColorTable.get(electricity_type), 0.1).set_ease(Tween.EASE_IN)


func clear_core() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($Control/Core, "color", Tables.ElectricityColorTable.get(Electricity.Type.WHITE), 0.1).set_ease(Tween.EASE_IN)


func output_electricity(dir: Direction) -> void:
	if line_disabled_array[dir] == true:
		return
	if line_outputable_array[dir] == false:
		return
	line_outputting_array[dir] = true
	electricity_array[dir].output(line_output_type_array[dir])
	
	
func output_electricity_with_type(type: Electricity.Type, dir: Direction) -> void:
	if line_disabled_array[dir] == true:
		return
	if line_outputable_array[dir] == false:
		return
	line_outputting_array[dir] = true
	electricity_array[dir].output(type)
	
	
func input_electricity(type: Electricity.Type, dir: Direction) -> void:
	if line_disabled_array[dir] == true:
		return
	if line_inputable_array[dir] == false:
		return
	if check_line_allow_input_type(type, dir) == false:
		return
	line_inputting_array[dir] = true
	electricity_array[dir].input(type)
	await get_tree().create_timer(0.4).timeout
	fill_core(type)
	
	
func vanish_electricity() -> void:
	clear_core()
	for electricity: Electricity in electricity_array:
		electricity.vanish()
	
	
func check_line_allow_input_type(type: Electricity.Type, dir: Direction) -> bool:
	if line_allow_input_type_array[dir] == AllowInputType.ALL:
		return true
	if line_allow_input_type_array[dir] == type:
		return true
	else:
		return false
		
		
func rotate(deg: int, with_anim: bool = false) -> void:
	current_deg = deg
	if with_anim:
		z_index = 100
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(self, "scale", Vector2.ONE * 1.2, 0.1).set_ease(Tween.EASE_OUT)
		tween.chain().tween_property(self, "rotation", deg_to_rad(deg), 0.1)
		tween.chain().tween_property(self, "scale", Vector2.ONE * 1.0, 0.1).set_ease(Tween.EASE_IN)
		tween.tween_callback(func() -> void: z_index = 0)
	else:
		rotation = deg_to_rad(deg)
	$Control/Disdetachabled.rotation -= rotation
	var step: int = 0
	if deg == 90:
		step = 1
	elif deg == 180:
		step = 2
	elif step == 270:
		step = 3
	rotate_array(line_disabled_array, step)
	rotate_array(line_inputable_array, step)
	rotate_array(line_outputable_array, step)
	rotate_array(line_allow_input_type_array, step)
	rotate_array(line_output_type_array, step)
	rotate_array(electricity_array, step)
	rotate_array(line_outputting_array, step)
	rotate_array(line_inputting_array, step)
	
	
func rotate_array(in_array: Array, step: int) -> void:
	if step == 0:
		return
	var length: int = in_array.size()
	step = (step + length) % length
	var temp: Array = in_array.duplicate()
	for i in range(length):
		in_array[(i + step) % length] = temp[i]


func detach() -> void:
	if not Globals.dragging and not Globals.installing:
		var main: Main = get_tree().get_first_node_in_group("main")
		main.active_level.on_element_uninstalled(owner)


func hint_disdetachabled() -> void:
	$Control/Disdetachabled/AnimationPlayer.play("Disdetachabled")


func rotate_90deg() -> void:
	current_deg += 90
	rotate(current_deg, true)


func _on_button_gui_input(event: InputEvent) -> void:
	var local_mouse_position: Vector2 = $Control/Button.get_local_mouse_position()
	var button_size: Vector2 = $Control/Button.size
	if local_mouse_position.x >= 0 and local_mouse_position.x <= button_size.x and \
	local_mouse_position.y >= 0 and local_mouse_position.y <= button_size.y:
		pass
	else:
		return
		
	if event is InputEventMouseButton and event.is_released():
		if event.button_index == MOUSE_BUTTON_LEFT:
			if rotatable:
				rotate_90deg()
			else:
				hint_disdetachabled()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if detachabled:
				detach()
			else:
				hint_disdetachabled()
