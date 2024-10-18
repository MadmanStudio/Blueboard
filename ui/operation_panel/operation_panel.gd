extends CanvasLayer


@export var element_list: Array[String] = []
@export var level: Level

var element_button_tscn: PackedScene = load("res://ui/operation_panel/element_button.tscn")
var dragging_element_button: ElementButton


func _ready() -> void:
	for id in element_list:
		var ebtn: ElementButton = element_button_tscn.instantiate()
		ebtn.element_id = id
		ebtn.clicked.connect(element_button_clicked)
		ebtn.released.connect(hide_curve)
		$Panel/Panel/MarginContainer/GridContainer.add_child(ebtn)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if dragging_element_button == null:
			return
		if Input.is_action_pressed("Click"):
			if not dragging_element_button.inside_toolbox and Globals.dragging:
				var curve_start: Vector2 = dragging_element_button.global_position + dragging_element_button.size * 0.5
				show_and_update_curve(curve_start)
			else:
				hide_curve()
			
			
func show_and_update_curve(start: Vector2) -> void:
	$Curve.show()
	$Hover.show()
	$Curve.curve.set_point_position(0, start)
	var target: Vector2 = find_target_positon(start)
	$Curve.curve.set_point_position(1, target)
	$Hover.global_position = target - $Hover.size * 0.5
	var out_x: float = (target.x - start.x) * 0.5
	$Curve.curve.set_point_out(0, Vector2(out_x, out_x))
	if start.x < target.x:
		$Curve.curve.set_point_out(0, Vector2(out_x, -out_x))
		$Curve.curve.set_point_out(1, Vector2(-out_x, -out_x))
	
	
func find_target_positon(start: Vector2) -> Vector2:
	var target_position: Vector2
	var min_distance: float = INF
	for coords in level.blueboard_layer.get_used_cells():
		if level.element_matrix[coords.x][coords.y] != null:
			continue
		var tile_data: TileData = level.blueboard_layer.get_cell_tile_data(coords)
		if tile_data.get_custom_data("is_border"):
			continue
		var tile_position: Vector2 = tile_data.get_meta("rect").position
		var tile_size: Vector2 = tile_data.get_meta("rect").size
		$Hover.size = tile_size
		var center: Vector2 = tile_position + tile_size * 0.5
		print_debug(coords, tile_position)
		var distance: float = start.distance_to(center)
		if distance < min_distance:
			min_distance = distance
			target_position = center
	return target_position
		
	
	
func hide_curve() -> void:
	$Curve.hide()
	$Hover.hide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.owner is ElementButton:
		area.owner.inside_toolbox = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.owner is ElementButton:
		area.owner.inside_toolbox = false
		
	
func element_button_clicked(element_button: ElementButton) -> void:
	dragging_element_button = element_button


func _on_toolbox_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$AnimationPlayer.play("ToolboxEnter")
	else:
		$AnimationPlayer.play_backwards("ToolboxEnter")
		
		
func show_menu() -> void:
	Globals.allow_operate = false
	$MenuBG.show()
	var tween: Tween = get_tree().create_tween()
	$MenuBG/Buttons.modulate.a = 0
	$MenuBG/Buttons.visible = true
	tween.tween_property($MenuBG/Buttons, "modulate", Color.WHITE, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	

func _on_menu_button_button_down() -> void:
	show_menu()
