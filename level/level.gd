extends Node
class_name Level


@onready var map: Control = $Map

const TileSize = 32.0
const MinMapZoom = 1.0
const MaxMapZoom = 2.0
const MapZoomSpeed = 0.2
const MapZoomTime = 0.05

var zoom_focus_point: Vector2
var current_zoom: float = 1.0
var current_scale: Vector2 = Vector2(1.0, 1.0)
var zoom_tween: Tween

var mouse_button_right_down: bool = false
var mouse_button_right_down_position: Vector2
var map_position: Vector2

var tmx_map: Node2D
var blueboard_layer: TileMapLayer
var element_layer: TileMapLayer
var install_point_shown: bool = false

var element_matrix: Array
var blueboard_tile_data_matrix: Array
var matrix_size: Vector2i

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
	"hinderer": load("res://element/hinderer/element_H.tscn"),
	"jumper_in": load("res://element/jumper/element_jumer_in.tscn"),
	"jumper_out": load("res://element/jumper/element_jumer_out.tscn"),
	"line_one": load("res://element/line/element_line_one.tscn"),
	"line_two": load("res://element/line/element_line_two.tscn"),
	"line_three": load("res://element/line/element_line_three.tscn"),
	"line_four": load("res://element/line/element_line_four.tscn")
}


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
		var element_layer_rect: Rect2i = element_layer.get_used_rect()
		map.position -= center.position
		for element_coords in element_layer.get_used_cells():
			var tile_data: TileData = element_layer.get_cell_tile_data(element_coords)
			var id: String = tile_data.get_meta("id")
			var element_inst: Node2D = create_element(id, element_coords * TileSize, calculate_tile_rotation(tile_data))
			var relative_coords: Vector2i = get_element_relative_coords(element_coords)
			element_matrix[relative_coords.x][relative_coords.y] = element_inst
			element_layer.erase_cell(element_coords)
			
		
func get_element_relative_coords(element_coords: Vector2i) -> Vector2i:
	var blueboard_layer_rect: Rect2i = blueboard_layer.get_used_rect()
	return (Vector2i(element_layer.position) - Vector2i(blueboard_layer_rect.position)) + element_coords


func _input(event: InputEvent) -> void:
	if Globals.allow_operate == false:
		return
		
	if Input.is_action_just_pressed("Pan"):
		mouse_button_right_down = true
		mouse_button_right_down_position = event.position
		map_position = map.position
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
			map.position = map_position + (event.position - mouse_button_right_down_position)
		
	if Input.is_action_just_pressed("ZoomIn"):
		zoom_at_point(1 + MapZoomSpeed, map.get_local_mouse_position())
	elif Input.is_action_just_pressed("ZoomOut"):
		zoom_at_point(1 - MapZoomSpeed, map.get_local_mouse_position())
		
		
func zoom_at_point(zoom_change: float, point: Vector2) -> void:
	zoom_focus_point = point
	var new_zoom: float = clamp(current_zoom * zoom_change, MinMapZoom, MaxMapZoom)
	if zoom_tween:
		zoom_tween.kill()
	zoom_tween = get_tree().create_tween()
	zoom_tween.tween_method(update_zoom, current_zoom, new_zoom, 0.1)


func update_zoom(new_zoom: float) -> void:
	var zoom_center: Vector2 = zoom_focus_point
	var zoom_diff: float = new_zoom / current_zoom
	map.scale = Vector2.ONE * new_zoom
	current_scale = map.scale
	map.position -= (zoom_center * map.scale * (zoom_diff - 1))
	current_zoom = new_zoom
		
		
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
			var new_tile_data: TileData = blueboard_layer.get_cell_tile_data(tile_coords)
			var tile_position: Vector2 = map.global_position + tile_coords * TileSize * current_scale
			var tile_size: Vector2 = TileSize * current_scale
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
	var element_id: String = element_button.element_id
	var installed_pos: Vector2 = element_button.installed_coords * TileSize
	var created_pos: Vector2 = element_layer.to_local(element_button.global_position)
	var element_inst: Node2D = create_element(element_id, created_pos, 0, 2.0)
	element_button.queue_free()
	var tween: Tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(element_inst, "position", installed_pos, 0.05).set_ease(Tween.EASE_IN)
	tween.tween_property(element_inst, "scale", current_scale, 0.05).set_ease(Tween.EASE_IN)
	
	
func create_element(id: String, pos: Vector2, deg: int, scale: float = 1.0) -> Node2D:
	var element_inst: Node2D = ElementTable.get(id).instantiate()
	element_inst.position = pos
	element_inst.get_child(0).rotate(deg)
	element_inst.scale = Vector2(scale, scale)
	element_layer.add_child(element_inst)
	return element_inst
		
		
