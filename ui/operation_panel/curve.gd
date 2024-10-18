extends Path2D

@export var line_color: Color = Color.WHITE
@export var line_width: float = 2.0
@export var dash_length: float = 20.0
@export var gap_length: float = 10.0
@export var speed: float = 50.0

var offset: float = 0.0


func _process(delta: float) -> void:
	offset -= speed * delta
	offset = fmod(offset, dash_length + gap_length)
	if offset < 0:
		offset += dash_length + gap_length
	queue_redraw()
	
	
func _draw() -> void:
	var points: PackedVector2Array = curve.get_baked_points()
	
	var current_length: float = 0.0
	var drawing: bool = true
	var segment_start: int = 0
	
	for i in range(1, points.size()):
		var segment_length: float = points[i].distance_to(points[i - 1])
		current_length += segment_length
		
		var dash_end: float = fmod(current_length + offset, dash_length + gap_length)
		if dash_end > dash_length:
			if drawing:
				draw_line(points[segment_start], points[i], line_color, line_width)
				drawing = false
			segment_start = i
		elif not drawing:
			drawing = true
			segment_start = i - 1
			
	if drawing:
		draw_line(points[segment_start], points[-1], line_color, line_width)
