@tool
extends Button
class_name ElementButton


signal clicked(element_button: ElementButton)
signal released(element_button: ElementButton)
signal element_installed(element_button: ElementButton)


var is_inside_dropable: bool = false
var offset: Vector2
var inside_toolbox: bool = true
var dragging: bool = false
var ready_to_install: bool = false
var installed_coord: Vector2
var ebtnc: ElementButtonContainer


@export var element_id: String:
	set(new_value):
		element_id = new_value
		if Tables.ElementIconTable.has(new_value):
			$Icon.texture = load(Tables.ElementIconTable.get(new_value))


func _on_mouse_entered() -> void:
	Globals.allow_zoom = false
	if Input.is_action_pressed("Pan"):
		return
	if not Globals.dragging and not ready_to_install:
		scale = Vector2.ONE * 1.06


func _on_mouse_exited() -> void:
	Globals.allow_zoom = true
	if not Globals.dragging and not ready_to_install:
		scale = Vector2.ONE * 1.0


func _on_button_down() -> void:
	z_index = 100
	if not Globals.dragging:
		Globals.dragging = true
		dragging = true
		offset = get_global_mouse_position() - global_position
		clicked.emit(self)


func _on_button_up() -> void:
	z_index = 1
	if Globals.dragging:
		if inside_toolbox == true or ready_to_install == false:
			position = Vector2.ZERO
			ebtnc.set_count(ebtnc.count)
		else:
			Globals.installing = true
			element_installed.emit(self)
		Globals.dragging = false
		dragging = false
		released.emit(self)
		
		
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if dragging:
			global_position = get_global_mouse_position() - offset


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if not inside_toolbox:
		ready_to_install = true
	else:
		ready_to_install = false


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	ready_to_install = false


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.owner is OperationPanel:
		inside_toolbox = true
		ready_to_install = false


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.owner is OperationPanel:
		inside_toolbox = false
		if $VisibleOnScreenNotifier2D.is_on_screen():
			ready_to_install = true
