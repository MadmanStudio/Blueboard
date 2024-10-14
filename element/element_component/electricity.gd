extends Line2D
class_name Electricity


enum Type
{
	RED, BLUE, YELLOW, PURPLE, ORANGE, GREEN, WHITE
}


func input(type: Type) -> void:
	default_color = Tables.ElectricityColorTable.get(type)
	$AnimationPlayer.play("Input")


func output(type: Type) -> void:
	default_color = Tables.ElectricityColorTable.get(type)
	$AnimationPlayer.play("Output")
	
	
func vanish() -> void:
	$AnimationPlayer.play("RESET")
	
	
func retract() -> void:
	$AnimationPlayer.play_backwards("Output")
