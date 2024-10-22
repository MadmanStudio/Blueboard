extends Node
class_name Level


@onready var map: Node = $Map

const TileSize = 32.0
const MinMapZoom = Vector2.ONE
const MaxMapZoom = Vector2.ONE * 2.0
const MapZoomSpeed = 0.2
const MapZoomTime = 0.05
const Dirs: Array = [Vector2i(0, -1), Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0)]

var zoom_focus_point: Vector2
var current_zoom: Vector2 = Vector2.ONE
var zoom_tween: Tween

var mouse_button_right_down: bool = false
var mouse_button_right_down_position: Vector2

var tmx_map: Node2D
var blueboard_layer: TileMapLayer
var element_layer: TileMapLayer
var install_point_shown: bool = false

var element_matrix: Array
var blueboard_tile_data_matrix: Array
var matrix_size: Vector2i
var map_center: Vector2

var start_G_elements: Array = []

var ElementTable: Dictionary = {
	"G_red": load("res://element/generator/element_G_red.tscn"),
	"G_blue": load("res://element/generator/element_G_blue.tscn"),
	"G_yellow": load("res://element/generator/element_G_yellow.tscn"),
	"L_purple": load("res://element/leacher/element_L_purple.tscn"),
	"L_green": load("res://element/leacher/element_L_green.tscn"),
	"L_orange": load("res://element/leacher/element_L_orange.tscn"),
	"I_purple": load("res://element/intermixer/element_I_purple.tscn"),
	"I_green": load("res://element/intermixer/element_I_green.tscn"),
	"I_orange": load("res://element/intermixer/element_I_orange.tscn"),
	"T_y2b": load("res://element/transformer/element_T_yellow2blue.tscn"),
	"T_y2r": load("res://element/transformer/element_T_yellow2red.tscn"),
	"T_b2r": load("res://element/transformer/element_T_blue2red.tscn"),
	"T_b2y": load("res://element/transformer/element_T_blue2yellow.tscn"),
	"T_r2b": load("res://element/transformer/element_T_red2blue.tscn"),
	"T_r2y": load("res://element/transformer/element_T_red2yellow.tscn"),
	"hinderer": load("res://element/hinderer/element_H.tscn"),
	"jumper_in": load("res://element/line/element_jumer_in.tscn"),
	"jumper_out": load("res://element/line/element_jumer_out.tscn"),
	"line_one": load("res://element/line/element_line_one.tscn"),
	"line_two": load("res://element/line/element_line_two.tscn"),
	"line_three": load("res://element/line/element_line_three.tscn"),
	"line_four": load("res://element/line/element_line_four.tscn"),
	"light_purple": load("res://element/light/element_light_purple.tscn"),
	"light_blue": load("res://element/light/element_light_blue.tscn"),
	"light_red": load("res://element/light/element_light_red.tscn"),
	"light_green": load("res://element/light/element_light_green.tscn"),
	"light_orange": load("res://element/light/element_light_orange.tscn"),
	"light_yellow": load("res://element/light/element_light_yellow.tscn")
}

var element_button_tscn: PackedScene = load("res://ui/operation_panel/element_button.tscn")


func _ready() -> void:
	$OperationPanel.element_installed.connect(on_element_installed)
	tmx_map = map.get_child(0)
	if tmx_map != null:
		blueboard_layer = tmx_map.find_child("Blueboard")
		element_layer = tmx_map.find_child("Element")
		matrix_size = blueboard_layer.get_used_rect().size
		for r in matrix_size.x:
			var array_a: Array = []
			var array_b: Array = []
			for c in matrix_size.y:
				array_a.append(null)
				array_b.append(null)
			element_matrix.append(array_a)
			blueboard_tile_data_matrix.append(array_b)
		var center: Marker2D = tmx_map.find_child("point")
		map_center = center.position
		$Camera2D.position = center.position
		for element_coord in element_layer.get_used_cells():
			var tile_data: TileData = element_layer.get_cell_tile_data(element_coord)
			var id: String = tile_data.get_meta("id")
			var element_inst: Node2D = create_element(id, element_coord * TileSize, calculate_tile_rotation(tile_data))
			element_inst.get_child(0).id = id
			element_inst.get_child(0).rotatable = false
			element_inst.get_child(0).installed_coord = element_coord
			var relative_coords: Vector2i = get_element_relative_coords(element_coord)
			element_matrix[relative_coords.y][relative_coords.x] = element_inst
			element_layer.erase_cell(element_coord)
			if id.find("G_") != -1:
				start_G_elements.append(element_inst)
		for G_element in start_G_elements:
			propagate_electricity(G_element)
			
		
func get_element_relative_coords(element_coords: Vector2i) -> Vector2i:
	var blueboard_layer_rect: Rect2i = blueboard_layer.get_used_rect()
	return (Vector2i(element_layer.position) - Vector2i(blueboard_layer_rect.position)) + element_coords


func _input(event: InputEvent) -> void:
	if Globals.allow_operate == false:
		return
		
	if Input.is_action_just_pressed("Pan"):
		mouse_button_right_down = true
		mouse_button_right_down_position = event.position
	if Input.is_action_just_released("Pan"):
		mouse_button_right_down = false
	
	if Input.is_action_pressed("Click"):
		if Globals.dragging and install_point_shown == false:
			switch_blueboard_tile()
	if Input.is_action_just_released("Click"):
		if install_point_shown == true:
			switch_blueboard_tile()
		
	if event is InputEventMouseMotion:
		if mouse_button_right_down:
			$Camera2D.position -= event.relative / current_zoom
		
	if Input.is_action_just_pressed("ZoomIn") and not Globals.dragging:
		zoom_at_point(1 + MapZoomSpeed)
	elif Input.is_action_just_pressed("ZoomOut") and not Globals.dragging:
		zoom_at_point(1 - MapZoomSpeed)
		
		
func zoom_at_point(zoom_change: float) -> void:
	var new_zoom: Vector2 = current_zoom * zoom_change
	new_zoom = new_zoom.clamp(MinMapZoom, MaxMapZoom)
	if zoom_tween:
		zoom_tween.kill()
	zoom_tween = get_tree().create_tween()
	zoom_tween.tween_method(update_zoom, current_zoom, new_zoom, 0.1)


func update_zoom(new_zoom: Vector2) -> void:
	$Camera2D.zoom = new_zoom
	current_zoom = $Camera2D.zoom
		
		
func switch_blueboard_tile() -> void:
	if blueboard_layer == null:
		return
	install_point_shown = !install_point_shown
	for tile_coords in blueboard_layer.get_used_cells():
		var tile_data : TileData = blueboard_layer.get_cell_tile_data(tile_coords)
		if tile_data != null:
			var id: String = tile_data.get_custom_data("id")
			var new_atlas_coords: Vector2i = Tables.BlueboardTileAtlasCoordsTable.get(id)
			blueboard_layer.set_cell(tile_coords, 0, new_atlas_coords)
			var tile_global_pos: Vector2 = blueboard_layer.map_to_local(tile_coords) - TileSize * Vector2.ONE * 0.5
			var tile_position: Vector2 = (tile_global_pos - $Camera2D.global_position) * current_zoom + get_viewport().size * 0.5
			var tile_size: Vector2 = TileSize * current_zoom
			var tile_rect: Rect2 = Rect2(tile_position, tile_size)
			blueboard_tile_data_matrix[tile_coords.x][tile_coords.y] = tile_rect
			
			
func calculate_tile_rotation(tile_data: TileData) -> int:
	var flipped_h: bool = tile_data.flip_h
	var flipped_v: bool = tile_data.flip_v
	var flipped_d: bool = tile_data.transpose
	var rotation: int = 0
	if flipped_d:
		if flipped_h and flipped_v:
			rotation = 90
		elif flipped_h:
			rotation = 90
		elif flipped_v:
			rotation = 270
		else:
			rotation = 90
	else:
		if flipped_h and flipped_v:
			rotation = 180
	return rotation
	
	
func is_dropable(idxs: Vector2i) -> bool:
	if element_matrix[idxs.x][idxs.y] == null:
		return true
	else:
		return false
		
		
func on_element_installed(element_button: ElementButton) -> void:
	element_button.hide()
	var element_id: String = element_button.element_id
	var element_coords: Vector2i = element_button.installed_coord
	var installed_pos: Vector2 = element_coords * TileSize
	var button_viewport_pos: Vector2 = element_button.get_global_transform_with_canvas().origin
	element_button.queue_free()
	var viewport_size: Vector2 = get_viewport().size
	var centered_viewport_pos: Vector2 = button_viewport_pos - viewport_size / 2
	var world_pos: Vector2 = (centered_viewport_pos / current_zoom) + $Camera2D.global_position
	var created_pos: Vector2 = element_layer.to_local(world_pos)
	var element_inst: Node2D = create_element(element_id, created_pos, 0, 2.0 / current_zoom.x)
	element_inst.get_child(0).detachable = true
	element_inst.get_child(0).installed_coord = element_button.installed_coord
	element_inst.get_child(0).detached.connect(on_element_uninstalled)
	element_matrix[element_coords.y][element_coords.x] = element_inst
	var tween: Tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(element_inst, "position", installed_pos, 0.1).set_ease(Tween.EASE_IN)
	tween.tween_property(element_inst, "scale", Vector2.ONE, 0.1).set_ease(Tween.EASE_IN)
	tween.tween_callback(on_element_install_completed.bind(element_inst))
	
	
func on_element_install_completed(element: Node2D) -> void:
	Globals.installing = false
	propagate_electricity(element)
	
	
func create_element(id: String, pos: Vector2, deg: int, scale: float = 1.0) -> Node2D:
	var element_inst: Node2D = ElementTable.get(id).instantiate()
	element_inst.get_child(0).id = id
	element_inst.position = pos
	element_inst.scale = Vector2(scale, scale)
	element_layer.add_child(element_inst)
	element_inst.get_child(0).rotate(deg)
	element_inst.get_child(0).rotated.connect(on_element_rotated.bind(element_inst))
	return element_inst
		
		
func on_element_uninstalled(element: Node2D) -> void:
	var element_comp: ElementComponent = element.get_child(0)
	var element_id: String = element_comp.id
	var element_button: ElementButton = element_button_tscn.instantiate()
	element_matrix[element_comp.installed_coord.x][element_comp.installed_coord.y] = null
	element.queue_free()
	element_button.element_id = element_id
	element_button.global_position = element.global_position
	$OperationPanel.add_element_button(element_button)
	
	
func propagate_electricity(start_element: Node2D) -> void:
	if start_element == null:
		return
	var element_comp: ElementComponent = start_element.get_child(0)
	var queue: Array = []
	var visited: Dictionary = {}
	queue.append(start_element)
	visited[element_comp.installed_coord] = true
	while queue.size() > 0:
		var current_comp: ElementComponent = queue.pop_front().get_child(0)
		var x: int = current_comp.installed_coord.x
		var y: int = current_comp.installed_coord.y
		handle_propagate(current_comp, [
			element_matrix[y + Dirs[0].y][x + Dirs[0].x],
			element_matrix[y + Dirs[1].y][x + Dirs[1].x],
			element_matrix[y + Dirs[2].y][x + Dirs[2].x],
			element_matrix[y + Dirs[3].y][x + Dirs[3].x]
		])
		for dir: Vector2i in Dirs:
			var next_coord: Vector2i = current_comp.installed_coord + dir
			if next_coord.x >= 0 and next_coord.x < matrix_size.x and next_coord.y >= 0 and next_coord.y < matrix_size.y:
				var next_element: Node2D = element_matrix[next_coord.y][next_coord.x]
				if not visited.has(next_coord) and next_element != null:
					queue.append(next_element)
					visited[next_coord] = true
	
	
func extinguish_electricity(start_element: Node2D) -> void:
	var element_comp: ElementComponent = start_element.get_child(0)


func handle_propagate(center_comp: ElementComponent, surrounding_elements: Array) -> void:
	print_debug(surrounding_elements)
	var up_comp: ElementComponent = null
	var right_comp: ElementComponent = null
	var down_comp: ElementComponent = null
	var left_comp: ElementComponent = null
	if surrounding_elements[0] != null:
		up_comp = surrounding_elements[0].get_child(0)
	if surrounding_elements[1] != null:
		right_comp = surrounding_elements[1].get_child(0)
	if surrounding_elements[2] != null:
		down_comp = surrounding_elements[2].get_child(0)
	if surrounding_elements[3] != null:
		left_comp = surrounding_elements[3].get_child(0)
	var UP: ElementComponent.Direction = ElementComponent.Direction.UP
	var DOWN: ElementComponent.Direction = ElementComponent.Direction.DOWN
	var LEFT: ElementComponent.Direction = ElementComponent.Direction.LEFT
	var RIGHT: ElementComponent.Direction = ElementComponent.Direction.RIGHT
	if up_comp != null:
		handle_line(center_comp, up_comp, UP, DOWN)
	if right_comp != null:
		handle_line(center_comp, right_comp, RIGHT, LEFT)
	if down_comp != null:
		handle_line(center_comp, down_comp, DOWN, UP)
	if left_comp != null:
		handle_line(center_comp, left_comp, LEFT, RIGHT)
		
		
func handle_line(center_comp: ElementComponent, target_comp: ElementComponent, center_line_dir: ElementComponent.Direction, target_line_dir: ElementComponent.Direction) -> void:
	if center_comp.is_outputting(center_line_dir) and target_comp.is_outputting(target_line_dir):
		pass
	else:
		if center_comp.is_outputting(center_line_dir):
			if target_comp.is_inputable(target_line_dir):
				var cuot: Electricity.Type = center_comp.get_output_type(center_line_dir)
				if target_comp.get_allow_input_type(target_line_dir) == cuot:
					target_comp.input_electricity(cuot, target_line_dir)
		elif target_comp.is_outputting(target_line_dir):
			if center_comp.is_inputable(center_line_dir):
				var tdot: Electricity.Type = target_comp.get_output_type(target_line_dir)
				var center_allow_input_type: ElementComponent.AllowInputType = center_comp.get_allow_input_type(center_line_dir)
				if center_allow_input_type == tdot || center_allow_input_type == ElementComponent.AllowInputType.ALL:
					center_comp.input_electricity(tdot, center_line_dir, true)


func on_element_rotated(element: Node2D) -> void:
	element.get_child(0).vanish_electricity()
	propagate_electricity(element)
