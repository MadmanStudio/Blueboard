extends CanvasLayer


@export var element_list: Array[String] = []
@export var level: Level

var element_button_tscn: PackedScene = load("res://ui/operation_panel/element_button.tscn")
var dragging_element_button: ElementButton


func _ready() -> void:
	for id in element_list:
		var ebtn: ElementButton = element_button_tscn.instantiate()
		ebtn.element_id = id
		ebtn.clicked.connect(element_button_clicked)
		$Panel/Panel/MarginContainer/GridContainer.add_child(ebtn)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.owner is ElementButton:
		area.owner.ready_to_drop = false


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.owner is ElementButton:
		area.owner.ready_to_drop = true
		
		
func show_install_hint(element_pos: Vector2) -> void:
	pass
	
	
func element_button_clicked(element_button: ElementButton) -> void:
	print_debug("YES")


func _on_toolbox_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$AnimationPlayer.play("ToolboxEnter")
	else:
		$AnimationPlayer.play_backwards("ToolboxEnter")
		
		
func show_menu() -> void:
	Globals.allow_operate = false
	$MenuBG.show()
	var tween: Tween = get_tree().create_tween()
	$MenuBG/Buttons.modulate.a = 0
	$MenuBG/Buttons.visible = true
	tween.tween_property($MenuBG/Buttons, "modulate", Color.WHITE, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	

func _on_menu_button_button_down() -> void:
	show_menu()
