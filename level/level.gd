extends Node


@onready var map: Control = $Map

const MinMapScale = 1.0
const MaxMapScale = 2.0
const MapScaleStep = 0.1
const MapScaleTime = 0.05

var mouse_button_right_down: bool = false
var mouse_button_right_down_position: Vector2
var map_position: Vector2

var tmx_map: Node2D
var blueboard_layer: TileMapLayer
var element_layer: TileMapLayer
var install_point_shown: bool = false


func _ready() -> void:
	tmx_map = map.get_child(0)
	if tmx_map != null:
		blueboard_layer = tmx_map.find_child("Blueboard")
		element_layer = tmx_map.find_child("Element")
		var center: Marker2D = tmx_map.find_child("point")
		map.pivot_offset = center.position
		map.position -= center.position
		for element in element_layer.get_used_cells():
			print_debug(element_layer.get_cell_tile_data(element))
		


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Pan"):
		mouse_button_right_down = true
		mouse_button_right_down_position = event.position
		map_position = map.position
	if Input.is_action_just_released("Pan"):
		mouse_button_right_down = false
		
	if Input.is_action_pressed("Click"):
		if install_point_shown == false:
			switch_blueboard_tile()
	if Input.is_action_just_released("Click"):
		if install_point_shown == true:
			switch_blueboard_tile()
		
	if event is InputEventMouseMotion:
		if mouse_button_right_down:
			map.position = map_position + (event.position - mouse_button_right_down_position)
		
	var tween: Tween = get_tree().create_tween()
	if Input.is_action_just_pressed("ZoomIn"):
		tween.tween_property(map, "scale", Vector2(
			min(map.scale.x + MapScaleStep, MaxMapScale),
			min(map.scale.y + MapScaleStep, MaxMapScale)
		), MapScaleTime).set_ease(Tween.EASE_OUT)
	elif Input.is_action_just_pressed("ZoomOut"):
		tween.tween_property(map, "scale", Vector2(
			max(map.scale.x - MapScaleStep, MinMapScale),
			max(map.scale.y - MapScaleStep, MinMapScale)
		), MapScaleTime).set_ease(Tween.EASE_OUT)
	else:
		tween.kill()
		
		
func switch_blueboard_tile() -> void:
	if blueboard_layer == null:
		return
	install_point_shown = !install_point_shown
	for tile_coord in blueboard_layer.get_used_cells():
		var tile_data : TileData = blueboard_layer.get_cell_tile_data(tile_coord)
		if tile_data != null:
			var id: String = tile_data.get_custom_data("id")
			var new_atlas_coord: Vector2i = Tables.BlueboardTileAtlasCoordTable.get(id)
			blueboard_layer.set_cell(tile_coord, 0, new_atlas_coord)
			
