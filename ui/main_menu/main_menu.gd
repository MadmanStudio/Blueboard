extends Control


@onready var L_image: TextureRect = $L
@onready var I_image: TextureRect = $I
@onready var G_image: TextureRect = $G
@onready var H_image: TextureRect = $H
@onready var T_image: TextureRect = $T
@onready var any_key_label: Label = $AnyKey

# 字体抖动的角度
@export var shake_rotation: float = 8.0
# 字体抖动计时开始时选取的区间
@export var min_shake_time: float = 0.4
@export var max_shake_time: float = 0.5


func _ready() -> void:
	bind_shake_event(L_image)
	bind_shake_event(I_image)
	bind_shake_event(G_image)
	bind_shake_event(H_image)
	bind_shake_event(T_image)


func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouseButton:
		$AnimationPlayer.stop()
		get_tree().quit()
		
		
func bind_shake_event(image: TextureRect) -> void:
	var timer: Timer = image.get_child(0)
	timer.start(randf_range(min_shake_time, max_shake_time))
	timer.connect("timeout", shake_image.bind(image))
		
		
func shake_image(image: TextureRect) -> void:
	var dir: float = [-1.0, 1.0].pick_random()
	image.rotation = shake_rotation * deg_to_rad(dir)
