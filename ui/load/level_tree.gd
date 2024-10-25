extends Control


const h_offset: float = 100.0
const v_offset: float = 100.0
const center: Vector2 = Vector2(464, 320)

var main: Main
var level_node_tscn: PackedScene = load(Paths.level_node)
var left: bool = true
var level_nodes: Array = []

var selected_level_name: String
var selected_map_path: String
var selected_next_level: String
var selected_element_dict: Dictionary


func _ready() -> void:
	SaveManager.verify_save_path()
	SaveManager.load_game()
	main = get_tree().get_first_node_in_group("main")
	var height: int = 0
	for key: String in main.level_data.keys():
		var level_node: LevelNode = level_node_tscn.instantiate()
		level_node.z_index = 1
		level_node.level_name = key
		level_node.map_path = main.level_data.get(key)["map_path"]
		level_node.next_level = main.level_data.get(key)["next_level"]
		level_node.element_dict = main.level_data.get(key)["element_dict"]
		level_node.clicked.connect(select_level_node)
		if left:
			left = false
			level_node.position += Vector2(-h_offset, height * v_offset)
		else:
			left = true
			level_node.position += Vector2(h_offset, height * v_offset)
		height += 1
		add_child(level_node)
		if level_nodes.size() > 0:
			var last_node: LevelNode = level_nodes.back()
			var line: Line2D = Line2D.new()
			var line_start: Vector2 = level_node.position + level_node.size * 0.5
			var line_end: Vector2 = last_node.position + last_node.size * 0.5
			line.add_point(line_start)
			line.add_point(line_end)
			line.width = 4.0
			line.default_color = Tables.ElectricityColorTable.values().pick_random()
			add_child(line)
		level_nodes.append(level_node)
		
	if level_nodes.size() > 0:
		select_level_node(level_nodes[0])
		
		
func select_level_node(level_node: LevelNode) -> void:
	for node: LevelNode in level_nodes:
		node.unselect()
	level_node.select()
	selected_level_name = level_node.level_name
	selected_map_path = level_node.map_path
	selected_next_level = level_node.next_level
	selected_element_dict = level_node.element_dict
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "position", center - level_node.position, 0.6).set_ease(Tween.EASE_IN_OUT)
	
