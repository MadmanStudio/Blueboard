extends Control


var vsp1: VideoStreamPlayer = null
var vsp2: VideoStreamPlayer = null
var vsp3: VideoStreamPlayer = null
var vsp4: VideoStreamPlayer = null


func _ready() -> void:
	if has_node("MarginContainer/Main/Left/Panel/VideoStreamPlayer"):
		vsp1 = get_node("MarginContainer/Main/Left/Panel/VideoStreamPlayer")
	if has_node("MarginContainer/Main/Left/Panel2/VideoStreamPlayer"):
		vsp2 = get_node("MarginContainer/Main/Left/Panel2/VideoStreamPlayer")
	if has_node("MarginContainer/Main/Right/Panel/VideoStreamPlayer"):
		vsp3 = get_node("MarginContainer/Main/Right/Panel/VideoStreamPlayer")
	if has_node("MarginContainer/Main/Right/Panel2/VideoStreamPlayer"):
		vsp4 = get_node("MarginContainer/Main/Right/Panel2/VideoStreamPlayer")


func play_all_video() -> void:
	if vsp1 != null:
		vsp1.play()
	if vsp2 != null:
		vsp2.play()
	if vsp3 != null:
		vsp3.play()
	if vsp4 != null:
		vsp4.play()
	
	
func stop_all_video() -> void:
	if vsp1 != null:
		vsp1.stop()
	if vsp2 != null:
		vsp2.stop()
	if vsp3 != null:
		vsp3.stop()
	if vsp4 != null:
		vsp4.stop()
