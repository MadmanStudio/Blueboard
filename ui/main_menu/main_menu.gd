extends Control


@onready var L_image: TextureRect = $Control/L
@onready var I_image: TextureRect = $Control/I
@onready var G_image: TextureRect = $Control/G
@onready var H_image: TextureRect = $Control/H
@onready var T_image: TextureRect = $Control/T
@onready var any_key_label: Label = $AnyKeyToStart

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
		start()
		
		
func bind_shake_event(image: TextureRect) -> void:
	var timer: Timer = image.get_child(0)
	timer.start(randf_range(min_shake_time, max_shake_time))
	timer.connect("timeout", shake_image.bind(image))
		
		
func shake_image(image: TextureRect) -> void:
	var dir: float = [-1.0, 1.0].pick_random()
	image.rotation = shake_rotation * deg_to_rad(dir)
	
	
func start() -> void:
	any_key_label.hide()
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($Control, "modulate", Color(1.0, 1.0, 1.0, 0.0), 1)
	tween.tween_callback(load_level)
	
	
func load_level() -> void:
	var main: Main = get_tree().get_first_node_in_group("main")
	main.load_scene(Paths.map_L_home)
