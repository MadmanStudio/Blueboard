@tool
extends Button
class_name ElementButton


signal clicked(element_button: ElementButton)
signal released


var is_inside_dropable: bool = false
var offset: Vector2
var initial_pos: Vector2
var inside_toolbox: bool = true
var dragging: bool = false


@export var element_id: String:
	set(new_value):
		element_id = new_value
		if Tables.ElementIconTable.has(new_value):
			$Icon.texture = load(Tables.ElementIconTable.get(new_value))


func _on_mouse_entered() -> void:
	if Input.is_action_pressed("Pan"):
		return
	if not Globals.dragging:
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(self, "scale", Vector2(1.06, 1.06), 0.06).set_ease(Tween.EASE_OUT)


func _on_mouse_exited() -> void:
	if not Globals.dragging:
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1).set_ease(Tween.EASE_OUT)


func _on_button_down() -> void:
	if not Globals.dragging:
		Globals.dragging = true
		dragging = true
		initial_pos = global_position
		offset = get_global_mouse_position() - global_position
		clicked.emit(self)


func _on_button_up() -> void:
	if Globals.dragging:
		Globals.dragging = false
		dragging = false
		if inside_toolbox == true:
			global_position = initial_pos
		released.emit()
		
		
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if dragging:
			global_position = get_global_mouse_position() - offset
