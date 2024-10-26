extends CanvasLayer



func _on_button_button_up() -> void:
	var main: Main = get_tree().get_first_node_in_group("main")
	main.load_scene(Paths.main_menu)
