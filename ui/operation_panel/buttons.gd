extends Control

@onready var back_button: Label = $Back
@onready var manual_button: Label = $Manual
@onready var main_menu_button: Label = $MainMenu

var tween: Tween


func _ready() -> void:
	back_button.set_meta("size_x", back_button.size.x)
	manual_button.set_meta("size_x", manual_button.size.x)
	main_menu_button.set_meta("size_x", main_menu_button.size.x)


func _on_back_button_mouse_entered() -> void:
	expand_button(back_button)
	
	
func _on_back_button_mouse_exited() -> void:
	minish_button(back_button)
	
	
func _on_manual_button_mouse_entered() -> void:
	expand_button(manual_button)


func _on_manual_button_mouse_exited() -> void:
	minish_button(manual_button)
	
	
func _on_main_menu_button_mouse_entered() -> void:
	expand_button(main_menu_button)


func _on_main_menu_button_mouse_exited() -> void:
	minish_button(main_menu_button)
	
	
func expand_button(button: Label) -> void:
	tween = get_tree().create_tween()
	tween.tween_property(button, "size", Vector2(button.size.x - 32.0, button.size.y), 0.1)


func minish_button(button: Label) -> void:
	tween = get_tree().create_tween()
	tween.tween_property(button, "size", Vector2(button.get_meta("size_x"), button.size.y), 0.1)
	
	
func goto_main_menu() -> void:
	var main: Main = get_tree().get_first_node_in_group("main")
	main.load_scene(Paths.level)
	
	
func _exit_tree() -> void:
	if tween != null:
		tween.kill()


func _on_back_button_button_down() -> void:
	%MenuBG.hide()
	Globals.allow_operate = true
