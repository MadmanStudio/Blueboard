@tool
extends Control
class_name ElementComponent


signal detached(element: Node2D)
signal core_filled(type: Electricity.Type)
signal core_cleared
signal installed
signal uninstalled
signal rotated


var id: String
var detachable: bool = false
var current_deg: int = 0
var installed_coord: Vector2i

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

@onready var e1: Electricity = $Control/Electricities/Electricity1
@onready var e2: Electricity = $Control/Electricities/Electricity2
@onready var e3: Electricity = $Control/Electricities/Electricity3
@onready var e4: Electricity = $Control/Electricities/Electricity4
@onready var electricity_array: Array[Electricity] = [e1, e2, e3, e4]
var line_outputting_array: Array[bool] = [false, false, false, false]
var line_inputting_array: Array[bool] = [false, false, false, false]
	
	
func fill_core(electricity_type: Electricity.Type) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($Control/Core, "color", Tables.ElectricityColorTable.get(electricity_type), 0.1).set_ease(Tween.EASE_IN)


func clear_core() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($Control/Core, "color", Tables.ElectricityColorTable.get(Electricity.Type.WHITE), 0.1).set_ease(Tween.EASE_IN)


func output_electricity(dir: Direction, switch_flowing_color: bool = false) -> void:
	if line_outputable_array[dir] == false:
		return
	line_outputting_array[dir] = true
	electricity_array[dir].output(line_output_type_array[dir], switch_flowing_color)
	
	
func output_electricity_with_type(type: Electricity.Type, dir: Direction, switch_flowing_color: bool = false) -> void:
	if line_outputable_array[dir] == false:
		return
	line_outputting_array[dir] = true
	electricity_array[dir].output(type, switch_flowing_color)
	
	
func input_electricity(type: Electricity.Type, dir: Direction, switch_flowing_color: bool = false) -> void:
	if line_inputable_array[dir] == false:
		return
	if check_line_allow_input_type(type, dir) == false:
		return
	line_inputting_array[dir] = true
	electricity_array[dir].input(type, switch_flowing_color)
	core_filled.emit(type)
	for d: Direction in Direction.values():
		if d == dir:
			continue
		if line_outputable_array[d]:
			output_electricity(d)
			line_outputting_array[d] = true
	fill_core(type)
	
	
func fill_core_and_output(type: Electricity.Type) -> void:
	core_filled.emit(type)
	line_output_type_array = [type, type, type, type]
	for dir: Direction in Direction.values():
		if line_outputable_array[dir]:
			output_electricity(dir)
			line_outputting_array[dir] = true
	fill_core(type)
	
	
func vanish_electricity() -> void:
	clear_core()
	core_cleared.emit()
	for electricity: Electricity in electricity_array:
		electricity.vanish()
	line_inputting_array = [false, false, false, false]
	line_outputting_array = [false, false, false, false]
	
	
func disable() -> void:
	vanish_electricity()
	line_inputable_array = [false, false, false, false]
	line_outputable_array = [false, false, false, false]
	
	
func check_line_allow_input_type(type: Electricity.Type, dir: Direction) -> bool:
	if line_allow_input_type_array[dir] == AllowInputType.ALL:
		return true
	if line_allow_input_type_array[dir] == type:
		return true
	else:
		return false
		
		
func rotate(deg: int, with_anim: bool = false, step: int = 0) -> void:
	if with_anim:
		z_index = 100
		$Control/Electricities.hide()
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(self, "scale", Vector2.ONE * 1.2, 0.1).set_ease(Tween.EASE_OUT)
		tween.chain().tween_property(self, "rotation", deg_to_rad(deg), 0.1)
		tween.chain().tween_property(self, "scale", Vector2.ONE * 1.0, 0.1).set_ease(Tween.EASE_IN)
		tween.tween_callback(on_rotate_completed.bind(deg))
	else:
		rotation = deg_to_rad(deg)
	$Control/Disdetachabled.rotation -= rotation
	if step == 0:
		if deg == 90:
			step = 1
		elif deg == 180:
			step = 2
		elif deg == 270:
			step = 3
	roll_array(line_inputable_array, step)
	roll_array(line_outputable_array, step)
	roll_array(line_allow_input_type_array, step)
	roll_array(line_output_type_array, step)
	roll_array(electricity_array, step)
	roll_array(line_outputting_array, step)
	roll_array(line_inputting_array, step)
	
	
func on_rotate_completed(deg: int) -> void:
	z_index = 0
	$Control/Electricities.show()
	if deg != 0:
		rotated.emit()
	
	
func roll_array(in_array: Array, step: int) -> void:
	for i in range(step):
		roll_array_once(in_array)
		
		
func roll_array_once(in_array: Array) -> void:
	var last: Variant = in_array.back()
	var i: int = in_array.size() - 1
	while i > 0:
		in_array[i] = in_array[i - 1]
		i -= 1
	in_array[0] = last


func detach() -> void:
	detached.emit(owner)


func hint_disdetachabled() -> void:
	$Control/Disdetachabled/AnimationPlayer.play("Disdetachabled")


func rotate_90deg() -> void:
	current_deg += 90
	rotate(current_deg, true, 1)


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
			if detachable:
				detach()
			else:
				hint_disdetachabled()
				
				
func is_inputting(dir: Direction) -> bool:
	return line_inputting_array[dir]
	
	
func is_outputting(dir: Direction) -> bool:
	return line_outputting_array[dir]
	
	
func is_inputable(dir: Direction) -> bool:
	return line_inputable_array[dir]
	
	
func is_outputable(dir: Direction) -> bool:
	return line_outputable_array[dir]


func get_allow_input_type(dir: Direction) -> AllowInputType:
	return line_allow_input_type_array[dir]
	
	
func get_output_type(dir: Direction) -> Electricity.Type:
	return line_output_type_array[dir]
