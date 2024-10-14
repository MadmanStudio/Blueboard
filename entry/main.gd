extends Node
class_name Main


var loading: bool = false
var current_loaded_scene_path: String
var loaded_scene: PackedScene


func _ready() -> void:
	pass
	
	
func _process(_delta: float) -> void:
	if loading:
		var progress : Array = []
		ResourceLoader.load_threaded_get_status(current_loaded_scene_path, progress)
		if progress[0] == 1.0:
			on_load_scene_completed()
	
	
func load_scene(loaded_scene_path: String) -> void:
	$Loading.show()
	clear_canvas_layer($Level)
	ResourceLoader.load_threaded_request(loaded_scene_path)
	current_loaded_scene_path = loaded_scene_path
	loading = true
	
	
func on_load_scene_completed() -> void:
	loading = false
	loaded_scene = ResourceLoader.load_threaded_get(current_loaded_scene_path)
	$Loading.hide()
	$Level.add_child(loaded_scene.instantiate())
	
	
func clear_canvas_layer(canvas_layer: CanvasLayer) -> void:
	for node in canvas_layer.get_children():
		node.queue_free()
