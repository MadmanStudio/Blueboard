extends Control


signal page_fliped(current_page: int)


@export var page_flip: AudioStream

const MinPageIdx: int = 0
const MaxPageIdx: int = 4
const SwitchPageTime: float = 0.3
var current_page_idx: int = 0


func _on_previous_page_button_up() -> void:
	if current_page_idx > MinPageIdx:
		$BG/PreviousPage.disabled = false
		$BG/NextPage.disabled = false
		$BG.get_child(current_page_idx).hide()
		var tween: Tween = get_tree().create_tween()
		tween.tween_property($BG.get_child(current_page_idx), "modulate", Color.TRANSPARENT, SwitchPageTime)
		stop_all_video(current_page_idx)
		current_page_idx -= 1
		play_all_video(current_page_idx)
		if current_page_idx == MinPageIdx:
			$BG/PreviousPage.disabled = true
		$BG.get_child(current_page_idx).modulate = Color.TRANSPARENT
		$BG.get_child(current_page_idx).show()
		tween.chain().tween_property($BG.get_child(current_page_idx), "modulate", Color.WHITE, SwitchPageTime)
		SoundManager.play_sound(page_flip)
		page_fliped.emit(current_page_idx + 1)


func _on_next_page_button_up() -> void:
	if current_page_idx < MaxPageIdx:
		$BG/PreviousPage.disabled = false
		$BG/NextPage.disabled = false
		$BG.get_child(current_page_idx).hide()
		var tween: Tween = get_tree().create_tween()
		tween.tween_property($BG.get_child(current_page_idx), "modulate", Color.TRANSPARENT, SwitchPageTime)
		stop_all_video(current_page_idx)
		current_page_idx += 1
		play_all_video(current_page_idx)
		if current_page_idx == MaxPageIdx:
			$BG/NextPage.disabled = true
		$BG.get_child(current_page_idx).modulate = Color.TRANSPARENT
		$BG.get_child(current_page_idx).show()
		tween.chain().tween_property($BG.get_child(current_page_idx), "modulate", Color.WHITE, SwitchPageTime)
		SoundManager.play_sound(page_flip)
		page_fliped.emit(current_page_idx + 1)


func play_all_video(current_page_idx: int) -> void:
	var page: Node = $BG.get_child(current_page_idx)
	page.play_all_video()
	
	
func stop_all_video(current_page_idx: int) -> void:
	var page: Node = $BG.get_child(current_page_idx)
	page.stop_all_video()
