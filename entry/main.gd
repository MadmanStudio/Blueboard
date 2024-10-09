extends Node
class_name Main


func _ready() -> void:
	pass
	
	
func _process(delta: float) -> void:
	pass
	
	
func load_scene(load_scene: String) -> void:
	$Loading.show()
	clear_canvas_layer($Level)
	
	
func clear_canvas_layer(canvas_layer: CanvasLayer) -> void:
	for node in canvas_layer.get_children():
		node.queue_free()
