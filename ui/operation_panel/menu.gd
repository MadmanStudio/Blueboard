extends Control

@onready var back_button: Label = $Buttons/Back
@onready var manual_button: Label = $Buttons/Manual
@onready var main_menu_button: Label = $Buttons/MainMenu

var tween: Tween
var main: Main
var book_shown: bool = false


func _ready() -> void:
	main = get_tree().get_first_node_in_group("main")
	back_button.set_meta("size_x", back_button.size.x)
	manual_button.set_meta("size_x", manual_button.size.x)
	main_menu_button.set_meta("size_x", main_menu_button.size.x)


func _on_back_button_mouse_entered() -> void:
	main.play_sound(Main.SoundType.UI_HOVER)
	expand_button(back_button)
	
	
func _on_back_button_mouse_exited() -> void:
	minish_button(back_button)
	
	
func _on_manual_button_mouse_entered() -> void:
	main.play_sound(Main.SoundType.UI_HOVER)
	expand_button(manual_button)


func _on_manual_button_mouse_exited() -> void:
	minish_button(manual_button)
	
	
func _on_main_menu_button_mouse_entered() -> void:
	main.play_sound(Main.SoundType.UI_HOVER)
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
	main.load_scene(Paths.level)
	
	
func _exit_tree() -> void:
	if tween != null:
		tween.kill()


func _on_back_button_button_down() -> void:
	main.play_sound(Main.SoundType.UI_CLICK)
	hide()
	Globals.allow_operate = true
	$Book.stop_all_video($Book.current_page_idx)


func _on_main_menu_button_button_down() -> void:
	main.play_sound(Main.SoundType.UI_CLICK)
	main.load_scene(Paths.main_menu)


func _on_manual_button_toggled(toggled_on: bool) -> void:
	main.play_sound(Main.SoundType.UI_CLICK)
	if toggled_on:
		book_shown = true
		$AnimationPlayer.play("TakeOutBook")
		$Book.play_all_video($Book.current_page_idx)
	else:
		book_shown = false
		$AnimationPlayer.play_backwards("TakeOutBook")
		$Book.stop_all_video($Book.current_page_idx)
