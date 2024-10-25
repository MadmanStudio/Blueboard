extends Node
class_name Level


@onready var map: Node = $Map

const TileSize = 32.0
const MinMapZoom = Vector2.ONE
const MaxMapZoom = Vector2.ONE * 2.0
const MapZoomSpeed = 0.2
const MapZoomTime = 0.05
const Dirs: Array = [Vector2i(-1, 0), Vector2i(0, 1), Vector2i(1, 0), Vector2i(0, -1)]

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
var start_light_elements: Array = []
var ElementTable: Dictionary = {}
var element_button_tscn: PackedScene = load(Paths.element_button)
var main: Main

var level_name: String
var next_level: String
var map_path: String
var element_dict: Dictionary


func _ready() -> void:
	main = get_tree().get_first_node_in_group("main")
	main.max_level = level_name
	SaveManager.save_game()
	$Map.add_child(load(map_path).instantiate())
	$OperationPanel/LevelName.text = level_name
	$OperationPanel.element_dict = element_dict
	$OperationPanel.update_toolbox()
	
	for key: String in Tables.ElementPathTable.keys():
		ElementTable[key] = load(Tables.ElementPathTable.get(key))
	$OperationPanel.element_installed.connect(on_element_installed)
	tmx_map = map.get_child(0)
	if tmx_map != null:
		blueboard_layer = tmx_map.find_child("Blueboard")
		element_layer = tmx_map.find_child("Element")
		var layer_size: Vector2i = blueboard_layer.get_used_rect().size
		matrix_size = Vector2i(layer_size.y, layer_size.x)
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
			var element_inst: Node2D = create_element(id, element_coord * TileSize, calculate_tile_deg(tile_data))
			element_inst.get_child(0).id = id
			element_inst.get_child(0).rotatable = false
			element_inst.get_child(0).installed_coord = Vector2i(element_coord.y, element_coord.x)
			var relative_coord: Vector2i = get_element_relative_coord(element_coord)
			element_matrix[relative_coord.y][relative_coord.x] = element_inst
			element_layer.erase_cell(element_coord)
			if id.find("G_") != -1:
				start_G_elements.append(element_inst)
			if id.find("light_") != -1:
				start_light_elements.append(element_inst)
		for G_element: Node2D in start_G_elements:
			propagate_electricity(G_element)
			
		
func get_element_relative_coord(element_coords: Vector2i) -> Vector2i:
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
		if mouse_button_right_down and Globals.allow_pan:
			$Camera2D.position -= event.relative / current_zoom
		
	if Input.is_action_just_pressed("ZoomIn") and not Globals.dragging and Globals.allow_zoom:
		zoom_at_point(1 + MapZoomSpeed)
	elif Input.is_action_just_pressed("ZoomOut") and not Globals.dragging and Globals.allow_zoom:
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
	for tile_coord in blueboard_layer.get_used_cells():
		var tile_data : TileData = blueboard_layer.get_cell_tile_data(tile_coord)
		if tile_data != null:
			var id: String = tile_data.get_custom_data("id")
			var new_atlas_coord: Vector2i = Tables.BlueboardTileAtlasCoordsTable.get(id)
			blueboard_layer.set_cell(tile_coord, 0, new_atlas_coord)
			var tile_global_pos: Vector2 = blueboard_layer.map_to_local(tile_coord) - TileSize * Vector2.ONE * 0.5
			var tile_position: Vector2 = (tile_global_pos - $Camera2D.global_position) * current_zoom + get_viewport().size * 0.5
			var tile_size: Vector2 = TileSize * current_zoom
			var tile_rect: Rect2 = Rect2(tile_position, tile_size)
			blueboard_tile_data_matrix[tile_coord.y][tile_coord.x] = tile_rect
			
			
func calculate_tile_deg(tile_data: TileData) -> int:
	var flipped_h: bool = tile_data.flip_h
	var flipped_v: bool = tile_data.flip_v
	var flipped_d: bool = tile_data.transpose
	var deg: int = 0
	if flipped_d:
		if flipped_h and flipped_v:
			deg = 90
		elif flipped_h:
			deg = 90
		elif flipped_v:
			deg = 270
		else:
			deg = 90
	else:
		if flipped_h and flipped_v:
			deg = 180
	return deg
	
	
func is_dropable(idxs: Vector2i) -> bool:
	if element_matrix[idxs.x][idxs.y] == null:
		return true
	else:
		return false
		
		
func on_element_installed(element_button: ElementButton) -> void:
	element_button.hide()
	var element_id: String = element_button.element_id
	var element_coord: Vector2i = element_button.installed_coord
	var installed_pos: Vector2 = Vector2(element_coord.y, element_coord.x) * TileSize
	var button_viewport_pos: Vector2 = element_button.get_global_transform_with_canvas().origin
	element_button.queue_free()
	var viewport_size: Vector2 = get_viewport().size
	var centered_viewport_pos: Vector2 = button_viewport_pos - viewport_size / 2
	var world_pos: Vector2 = (centered_viewport_pos / current_zoom) + $Camera2D.global_position
	var created_pos: Vector2 = element_layer.to_local(world_pos)
	var element_inst: Node2D = create_element(element_id, created_pos, 0, 2.0 / current_zoom.x)
	element_inst.get_child(0).detachable = true
	element_inst.get_child(0).installed_coord = element_button.installed_coord
	element_inst.get_child(0).uninstalled.connect(on_element_uninstalled)
	element_matrix[element_coord.x][element_coord.y] = element_inst
	var tween: Tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(element_inst, "position", installed_pos, 0.1).set_ease(Tween.EASE_IN)
	tween.tween_property(element_inst, "scale", Vector2.ONE, 0.1).set_ease(Tween.EASE_IN)
	tween.tween_callback(on_element_install_completed.bind(element_inst))
	
	
func on_element_install_completed(element: Node2D) -> void:
	Globals.installing = false
	propagate_electricity(element)
	propagate_electricity(element)
	element.get_child(0).installed.emit()
	emit_any_surrounding_element_updated_signal(element)
	main.play_sound(Main.SoundType.INSTALLED)
	check_all_light()
	
	
func create_element(id: String, pos: Vector2, deg: int, scale: float = 1.0) -> Node2D:
	var element_inst: Node2D = ElementTable.get(id).instantiate()
	element_inst.set_meta("level", self)
	element_inst.get_child(0).id = id
	element_inst.position = pos
	element_inst.scale = Vector2(scale, scale)
	element_layer.add_child(element_inst)
	element_inst.get_child(0).rotate_completed.connect(on_element_rotate_completed.bind(element_inst))
	element_inst.get_child(0).rotate(deg)
	return element_inst
		
		
func on_element_uninstalled(element: Node2D) -> void:
	element.hide()
	var element_comp: ElementComponent = element.get_child(0)
	var element_id: String = element_comp.id
	var element_button: ElementButton = element_button_tscn.instantiate()
	element_comp.disable_before_free()
	element_matrix[element_comp.installed_coord.x][element_comp.installed_coord.y] = null
	propagate_electricity(element)
	element.queue_free()
	element_button.element_id = element_id
	$OperationPanel.add_element_button(element_button)
	emit_any_surrounding_element_updated_signal(element)
	main.play_sound(Main.SoundType.UNINSTALLED)
	
	
func BFS(start_element: Node2D, action: Callable) -> void:
	if start_element == null:
		return
	var element_comp: ElementComponent = start_element.get_child(0)
	var queue: Array = []
	var visited: Dictionary = {}
	queue.append(start_element)
	visited[element_comp.installed_coord] = true
	while queue.size() > 0:
		var current_element: Node2D = queue.pop_front()
		var current_comp: ElementComponent = current_element.get_child(0)
		action.call(current_comp, get_surrounding_elements(current_element))
		for dir: Vector2i in Dirs:
			var next_coord: Vector2i = current_comp.installed_coord + dir
			if next_coord.x >= 0 and next_coord.x < matrix_size.x and next_coord.y >= 0 and next_coord.y < matrix_size.y:
				var next_element: Node2D = element_matrix[next_coord.x][next_coord.y]
				if not visited.has(next_coord) and next_element != null:
					queue.append(next_element)
					visited[next_coord] = true
	
	
func propagate_electricity(start_element: Node2D) -> void:
	BFS(start_element, handle_propagate)


func handle_propagate(center_comp: ElementComponent, surrounding_elements: Array) -> void:
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
		handle_line_propagate(center_comp, up_comp, UP, DOWN)
	if right_comp != null:
		handle_line_propagate(center_comp, right_comp, RIGHT, LEFT)
	if down_comp != null:
		handle_line_propagate(center_comp, down_comp, DOWN, UP)
	if left_comp != null:
		handle_line_propagate(center_comp, left_comp, LEFT, RIGHT)
		
		
func handle_line_propagate(center_comp: ElementComponent, target_comp: ElementComponent, center_line_dir: ElementComponent.Direction, target_line_dir: ElementComponent.Direction) -> void:
	if center_comp.is_outputting(center_line_dir) and target_comp.is_outputting(target_line_dir):
		pass
	else:
		var cot: Electricity.Type = center_comp.get_output_type(center_line_dir)
		var tot: Electricity.Type = target_comp.get_output_type(target_line_dir)
		if center_comp.is_inputting(center_line_dir):
			if not target_comp.is_outputable(target_line_dir):
				center_comp.specific_vanish_electricity()
		if target_comp.is_inputting(target_line_dir):
			if not center_comp.is_outputting(center_line_dir):
				target_comp.specific_vanish_electricity()
		if center_comp.is_outputting(center_line_dir):
			if target_comp.is_inputable(target_line_dir):
				var target_allow_input_type: ElementComponent.AllowInputType = target_comp.get_allow_input_type(target_line_dir)
				if target_allow_input_type == cot || target_allow_input_type == ElementComponent.AllowInputType.ALL:
					target_comp.input_electricity(cot, target_line_dir, true)
		if target_comp.is_outputting(target_line_dir):
			if center_comp.is_inputable(center_line_dir):
				var center_allow_input_type: ElementComponent.AllowInputType = center_comp.get_allow_input_type(center_line_dir)
				if center_allow_input_type == tot || center_allow_input_type == ElementComponent.AllowInputType.ALL:
					center_comp.input_electricity(tot, center_line_dir, true)
				
				
func get_surrounding_elements(element: Node2D) -> Array:
	var current_comp: ElementComponent = element.get_child(0)
	var up_coord: Vector2i = current_comp.installed_coord + Dirs[0]
	var right_coord: Vector2i = current_comp.installed_coord + Dirs[1]
	var down_coord: Vector2i = current_comp.installed_coord + Dirs[2]
	var left_coord: Vector2i = current_comp.installed_coord + Dirs[3]
	return [
		element_matrix[up_coord.x][up_coord.y],
		element_matrix[right_coord.x][right_coord.y],
		element_matrix[down_coord.x][down_coord.y],
		element_matrix[left_coord.x][left_coord.y]
	]
	
	
func on_element_rotate_completed(element: Node2D) -> void:
	propagate_electricity(element)
	emit_any_surrounding_element_updated_signal(element)
	main.play_sound(Main.SoundType.INSTALLED)
	check_all_light()
	

func emit_any_surrounding_element_updated_signal(element: Node2D) -> void:
	var surrounding_elements: Array = get_surrounding_elements(element)
	for e: Node2D in surrounding_elements:
		if e != null:
			e.get_child(0).any_surrounding_element_updated.emit()


func _on_next_level_button_mouse_entered() -> void:
	main.play_sound(Main.SoundType.UI_HOVER)
	$AnimationPlayer.play("NextLevelButtonHovered")


func _on_next_level_button_mouse_exited() -> void:
	$AnimationPlayer.play_backwards("NextLevelButtonHovered")


func _on_next_level_button_button_down() -> void:
	main.play_sound(Main.SoundType.UI_CLICK)
	var next_level_data: Dictionary = main.level_data[next_level]
	Globals.allow_operate = true
	main.load_scene(Paths.level, {
		"map_path": next_level_data["map_path"],
		"next_level": next_level_data["next_level"],
		"level_name": next_level,
		"element_dict": next_level_data["element_dict"]
	})
	
	
func check_all_light() -> void:
	var all_light_lit: bool = true
	for light: Node2D in start_light_elements:
		if not light.lit:
			all_light_lit = false
	if all_light_lit:
		Globals.allow_operate = false
		$NextLevel.show()
