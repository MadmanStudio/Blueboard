extends Control


const MinPage: int = 0
const MaxPage: int = 3
const SwitchPageTime: float = 0.3
var current_page: int = 0


func _on_previous_page_button_down() -> void:
	if current_page > MinPage:
		$ColorRect.get_child(current_page).hide()
		var tween: Tween = get_tree().create_tween()
		tween.tween_property($ColorRect.get_child(current_page), "modulate", Color.TRANSPARENT, SwitchPageTime)
		current_page -= 1
		$ColorRect.get_child(current_page).modulate = Color.TRANSPARENT
		$ColorRect.get_child(current_page).show()
		tween.chain().tween_property($ColorRect.get_child(current_page), "modulate", Color.WHITE, SwitchPageTime)


func _on_next_page_button_down() -> void:
	if current_page < MaxPage:
		$ColorRect.get_child(current_page).hide()
		var tween: Tween = get_tree().create_tween()
		tween.tween_property($ColorRect.get_child(current_page), "modulate", Color.TRANSPARENT, SwitchPageTime)
		current_page += 1
		$ColorRect.get_child(current_page).modulate = Color.TRANSPARENT
		$ColorRect.get_child(current_page).show()
		tween.chain().tween_property($ColorRect.get_child(current_page), "modulate", Color.WHITE, SwitchPageTime)
