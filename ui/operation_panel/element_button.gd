@tool
extends Button


@export var element_id: String:
	set(new_value):
		element_id = new_value
		if Tables.ElementIconTable.has(new_value):
			$Icon.texture = load(Tables.ElementIconTable.get(new_value))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
