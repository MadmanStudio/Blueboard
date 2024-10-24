extends Control
class_name ElementButtonContainer


signal ebtn_removed(element_id: String, latest_count: int)


var count: int = 0


func add_element_button(element_button: ElementButton) -> void:
	element_button.position = Vector2.ZERO
	$Buttons.add_child(element_button)
	count += 1
	$Count.text = str(count)
	
	
func remove_element_button(element_button: ElementButton) -> void:
	$Buttons.remove_child(element_button)
	count -= 1
	ebtn_removed.emit(element_button.element_id, count)
	$Count.text = str(count)
	
	
func set_count(in_count: int) -> void:
	if in_count == 0:
		$Count.hide()
	else:
		$Count.show()
	$Count.text = str(in_count)
