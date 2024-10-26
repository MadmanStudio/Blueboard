extends CanvasLayer


var guide_texts: Array = [
	"""[wave amp=50 freq=2]
欢迎游玩蓝板系统
[/wave]""",
	"""[wave amp=50 freq=2]
在游戏开始之前请认真阅读操作手册[/wave]
	""",
		"""[wave amp=50 freq=2]
可以通过右上角的按钮找到操作手册[/wave]
	""",
]

var current_guide: int = 0
var main: Main
var confirm_click_count: int = 0


func _ready() -> void:
	main = get_tree().get_first_node_in_group("main")
	Globals.allow_operate = false
	show_guide_text()
	$Book.page_fliped.connect(on_page_fliped)
	
	
func _exit_tree() -> void:
	Globals.allow_operate = true
		
		
func show_guide_text() -> void:
	if current_guide < guide_texts.size():
		$RichTextLabel.text = guide_texts[current_guide]
		if current_guide == 2:
			$RichTextLabel.hide()
			$Book.show()
			$Book.play_all_video(0)
		current_guide += 1


func _on_button_button_up() -> void:
	show_guide_text()
	
	
func on_page_fliped(current_page: int) -> void:
	if current_page == $Book.MaxPageIdx + 1:
		$Confirm.show()
	else:
		$Confirm.hide()


func _on_confirm_button_mouse_entered() -> void:
	main.play_sound(Main.SoundType.UI_HOVER)
	$AnimationPlayer.play("ConfirmButtonHovered")


func _on_confirm_button_mouse_exited() -> void:
	$AnimationPlayer.play_backwards("ConfirmButtonHovered")


func _on_confirm_button_button_down() -> void:
	main.play_sound(Main.SoundType.UI_CLICK)
	confirm_click_count += 1
	if confirm_click_count == 1:
		$Book.hide()
		$RichTextLabel.show()
		show_guide_text()
	elif confirm_click_count == 2:
		Globals.allow_operate = true
		queue_free()
