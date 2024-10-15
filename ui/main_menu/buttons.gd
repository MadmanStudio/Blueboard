extends Control

@onready var start_button: Label = $Start
@onready var load_button: Label = $Load
@onready var exit_button: Label = $Exit

var tween: Tween


func _on_start_button_mouse_entered() -> void:
	expand_button(start_button)
	
	
func _on_start_button_mouse_exited() -> void:
	minish_button(start_button)
	
	
func _on_load_button_mouse_entered() -> void:
	expand_button(load_button)


func _on_load_button_mouse_exited() -> void:
	minish_button(load_button)
	
	
func _on_exit_button_mouse_entered() -> void:
	expand_button(exit_button)


func _on_exit_button_mouse_exited() -> void:
	minish_button(exit_button)
	
	
func expand_button(button: Label) -> void:
	tween = get_tree().create_tween()
	tween.tween_property(button, "size", Vector2(button.size.x + 32.0, button.size.y), 0.1)


func minish_button(button: Label) -> void:
	tween = get_tree().create_tween()
	tween.tween_property(button, "size", Vector2(button.size.x - 32.0, button.size.y), 0.1)
	
	
func start() -> void:
	load_level()
	
	
func load_level() -> void:
	var main: Main = get_tree().get_first_node_in_group("main")
	main.load_scene(Paths.map_L_home)


func _on_button_button_up() -> void:
	get_tree().quit()


func _on_start_button_down() -> void:
	var main: Main = get_tree().get_first_node_in_group("main")
	main.load_scene(Paths.level)
	
	
func _exit_tree() -> void:
	if tween != null:
		tween.kill()
