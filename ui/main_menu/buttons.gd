extends VBoxContainer

@onready var start_button: Label = $Start
@onready var continue_button: Label = $Continue
@onready var exit_button: Label = $Exit


func _on_start_button_mouse_entered() -> void:
	expand_button(start_button)
	
	
func _on_start_button_mouse_exited() -> void:
	minish_button(start_button)
	
	
func _on_continue_button_mouse_entered() -> void:
	expand_button(continue_button)


func _on_continue_button_mouse_exited() -> void:
	minish_button(continue_button)
	
	
func _on_exit_button_mouse_entered() -> void:
	expand_button(exit_button)


func _on_exit_button_mouse_exited() -> void:
	minish_button(exit_button)
	
	
func expand_button(button: Label) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(button, "position", Vector2(32.0, button.position.y), 0.1)


func minish_button(button: Label) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(button, "position", Vector2(0.0, button.position.y), 0.1)
