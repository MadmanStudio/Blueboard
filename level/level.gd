extends Node


@onready var map: Control = $Map

const MinMapScale = 1.0
const MaxMapScale = 2.0
const MapScaleStep = 0.05
const MapScaleTime = 0.1

var mouse_button_right_down: bool = false
var mouse_button_right_down_position: Vector2
var map_position: Vector2


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Pan"):
		mouse_button_right_down = true
		mouse_button_right_down_position = event.position
		map_position = map.position
	if Input.is_action_just_released("Pan"):
		mouse_button_right_down = false
		
	if event is InputEventMouseMotion:
		if mouse_button_right_down:
			map.position = map_position + (event.position - mouse_button_right_down_position)
		
	var tween: Tween = get_tree().create_tween()
	if Input.is_action_just_pressed("ZoomIn"):
		tween.tween_property(map, "scale", Vector2(
			min(map.scale.x + MapScaleStep, MaxMapScale),
			min(map.scale.y + MapScaleStep, MaxMapScale)
		), MapScaleTime)
	elif Input.is_action_just_pressed("ZoomOut"):
		tween.tween_property(map, "scale", Vector2(
			max(map.scale.x - MapScaleStep, MinMapScale),
			max(map.scale.y - MapScaleStep, MinMapScale)
		), MapScaleTime)
	else:
		tween.kill()
		
		
func _process(delta: float) -> void:
	print_debug(map.pivot_offset)
