extends Node
class_name Main


var loading: bool = false:
	set(new_state):
		loading = new_state
		if new_state == true:
			$Loading.show()
		else:
			$Loading.hide()


var current_loaded_scene_path: String
var loaded_scene: PackedScene


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color("#27292d"))
	
	
func _process(_delta: float) -> void:
	if loading:
		var progress : Array = []
		ResourceLoader.load_threaded_get_status(current_loaded_scene_path, progress)
		if progress[0] == 1.0:
			on_load_scene_completed()
	
	
func load_scene(loaded_scene_path: String) -> void:
	loading = true
	clear_level_layer()
	ResourceLoader.load_threaded_request(loaded_scene_path)
	current_loaded_scene_path = loaded_scene_path
	
	
func on_load_scene_completed() -> void:
	loaded_scene = ResourceLoader.load_threaded_get(current_loaded_scene_path)
	if loaded_scene != null:
		loading = false
		var scene: Node = loaded_scene.instantiate()
		$LevelLayer.add_child(scene)
	
	
func clear_level_layer() -> void:
	for node in $LevelLayer.get_children():
		node.queue_free()
