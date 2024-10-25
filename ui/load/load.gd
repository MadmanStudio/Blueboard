extends CanvasLayer


var main: Main


func _ready() -> void:
	main = get_tree().get_first_node_in_group("main")
	
	
func play_button_hover() -> void:
	main.play_sound(Main.SoundType.UI_HOVER)
	
	
func play_button_click() -> void:
	main.play_sound(Main.SoundType.UI_CLICK)


func _on_back_button_button_down() -> void:
	play_button_click()
	hide()


func _on_back_button_mouse_entered() -> void:
	play_button_hover()
	$AnimationPlayer.play("ExpandBackButton")


func _on_back_button_mouse_exited() -> void:
	$AnimationPlayer.play_backwards("ExpandBackButton")


func _on_start_button_button_down() -> void:
	play_button_click()
	main.load_scene(Paths.level, {
		"map_path": $LevelTree.selected_map_path,
		"next_level": $LevelTree.selected_next_level,
		"level_name": $LevelTree.selected_level_name,
		"element_dict": $LevelTree.selected_element_dict
	})


func _on_start_button_mouse_entered() -> void:
	play_button_hover()
	$AnimationPlayer.play("ExpandStartButton")


func _on_start_button_mouse_exited() -> void:
	$AnimationPlayer.play_backwards("ExpandStartButton")
