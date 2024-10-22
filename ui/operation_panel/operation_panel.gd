extends CanvasLayer
class_name OperationPanel


signal element_installed(element_button: ElementButton)


@export var element_list: Array[String] = []
@export var level: Level

var toolbox_icon: AtlasTexture = load("res://ui/operation_panel/res/toolbox_button.atlastex")
var close_icon: AtlasTexture = load("res://ui/operation_panel/res/close_button.atlastex")
var element_button_tscn: PackedScene = load("res://ui/operation_panel/element_button.tscn")
var dragging_element_button: ElementButton


func _ready() -> void:
	for id in element_list:
		var ebtn: ElementButton = element_button_tscn.instantiate()
		ebtn.size = Vector2(64.0, 64.0)
		ebtn.element_id = id
		ebtn.clicked.connect(element_button_clicked)
		ebtn.released.connect(on_element_button_released)
		ebtn.element_installed.connect(on_element_installed)
		ebtn.tree_exited.connect(on_queue_free)
		$Panel/Panel/MarginContainer/GridContainer.add_child(ebtn)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if dragging_element_button == null:
			return
		if Input.is_action_pressed("Click"):
			if dragging_element_button.inside_toolbox:
				hide_curve()
			if dragging_element_button.ready_to_install:
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
	for coord in level.blueboard_layer.get_used_cells():
		if level.element_matrix[coord.x][coord.y] != null:
			continue
		var tile_data: TileData = level.blueboard_layer.get_cell_tile_data(coord)
		if tile_data.get_custom_data("is_border"):
			continue
		var tile_position: Vector2 = level.blueboard_tile_data_matrix[coord.x][coord.y].position
		var tile_size: Vector2 = level.blueboard_tile_data_matrix[coord.x][coord.y].size
		$Hover.size = tile_size
		var center: Vector2 = tile_position + tile_size * 0.5
		var distance: float = start.distance_to(center)
		if distance < min_distance:
			min_distance = distance
			target_position = center
			dragging_element_button.installed_coord = coord
	return target_position
		
	
	
func on_queue_free() -> void:
	hide_curve()
	if Globals.dragging:
		Globals.dragging = false
	
	
func hide_curve() -> void:
	$Curve.hide()
	$Hover.hide()
	
	
func on_element_button_released(_element_button: ElementButton) -> void:
	hide_curve()
	
	
func on_element_installed(element_button: ElementButton) -> void:
	element_installed.emit(element_button)
	
	
func element_button_clicked(element_button: ElementButton) -> void:
	dragging_element_button = element_button


func _on_toolbox_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$AnimationPlayer.play("ToolboxEnter")
		$ToolboxButton.icon = close_icon
	else:
		$AnimationPlayer.play_backwards("ToolboxEnter")
		$ToolboxButton.icon = toolbox_icon
		
		
func show_menu() -> void:
	Globals.allow_operate = false
	$MenuBG.show()
	var tween: Tween = get_tree().create_tween()
	$MenuBG/Buttons.modulate.a = 0
	$MenuBG/Buttons.visible = true
	tween.tween_property($MenuBG/Buttons, "modulate", Color.WHITE, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	

func _on_menu_button_button_down() -> void:
	show_menu()


func _on_button_button_down() -> void:
	var main: Main = get_tree().get_first_node_in_group("main")
	main.load_scene(Paths.main_menu)
	
	
func add_element_button(element_button: ElementButton) -> void:
	element_button.clicked.connect(element_button_clicked)
	element_button.released.connect(on_element_button_released)
	element_button.element_installed.connect(on_element_installed)
	element_button.tree_exited.connect(on_queue_free)
	$Panel/Panel/MarginContainer/GridContainer.add_child(element_button)
