extends RigidBody2D
class_name BasePart


func _ready() -> void:
	main_ui.connect("start_battle", start_battle)
	

func start_battle():
	freeze = false
