extends CanvasLayer


@onready var L_image: TextureRect = $L
@onready var I_image: TextureRect = $I
@onready var G_image: TextureRect = $G
@onready var H_image: TextureRect = $H
@onready var T_image: TextureRect = $T
@onready var any_key_label: Label = $AnyKeyDown

# 字体抖动的角度
@export var shake_rotation: float = 8.0
# 字体抖动计时开始时选取的区间
@export var min_shake_time: float = 0.4
@export var max_shake_time: float = 0.5

var any_key_down: bool = false
var is_ready: bool = false
var main: Main


func _ready() -> void:
	main = get_tree().get_first_node_in_group("main")
	bind_shake_event(L_image)
	bind_shake_event(I_image)
	bind_shake_event(G_image)
	bind_shake_event(H_image)
	bind_shake_event(T_image)
	$Timer.timeout.connect(func() -> void: is_ready = true)


func _input(event: InputEvent) -> void:
	if not is_ready:
		return
	if event is InputEventKey or event is InputEventMouseButton:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP or\
			event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				return
		if any_key_down == false:
			any_key_down = true
			$AnyKeyDown.hide()
			$AnimationPlayer.pause()
			main.play_sound(Main.SoundType.UI_CLICK)
			show_menu_buttons()
		if event is InputEventKey:
			if event.keycode == KEY_ESCAPE && any_key_down == true:
				any_key_down = false
				$AnyKeyDown.show()
				$AnimationPlayer.play()
				$Buttons.hide()
		
		
func bind_shake_event(image: TextureRect) -> void:
	var timer: Timer = image.get_child(0)
	timer.start(randf_range(min_shake_time, max_shake_time))
	timer.connect("timeout", shake_image.bind(image))
		
		
func shake_image(image: TextureRect) -> void:
	var dir: float = [-1.0, 1.0].pick_random()
	image.rotation = shake_rotation * deg_to_rad(dir)
	
	
func show_menu_buttons() -> void:
	var tween: Tween = get_tree().create_tween()
	$Buttons.modulate.a = 0
	$Buttons.visible = true
	tween.tween_property($Buttons, "modulate", Color.WHITE, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	
