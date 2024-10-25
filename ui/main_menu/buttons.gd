extends Control

@onready var start_button: Label = $Start
@onready var load_button: Label = $Load
@onready var exit_button: Label = $Exit

var tween: Tween
var main: Main


func _ready() -> void:
	main = get_tree().get_first_node_in_group("main")


func _on_start_button_mouse_entered() -> void:
	main.play_sound(Main.SoundType.UI_HOVER)
	expand_button(start_button)
	
	
func _on_start_button_mouse_exited() -> void:
	minish_button(start_button)
	
	
func _on_load_button_mouse_entered() -> void:
	main.play_sound(Main.SoundType.UI_HOVER)
	expand_button(load_button)


func _on_load_button_mouse_exited() -> void:
	minish_button(load_button)
	
	
func _on_exit_button_mouse_entered() -> void:
	main.play_sound(Main.SoundType.UI_HOVER)
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
	main.load_scene(Paths.map_L_home)


func _on_button_button_up() -> void:
	main.play_sound(Main.SoundType.UI_CLICK)
	get_tree().quit()


func _on_start_button_down() -> void:
	main.play_sound(Main.SoundType.UI_CLICK)
	main.load_scene(Paths.level)
	
	
func _exit_tree() -> void:
	if tween != null:
		tween.kill()


func _on_load_button_button_down() -> void:
	main.play_sound(Main.SoundType.UI_CLICK)
	%Load.show()
