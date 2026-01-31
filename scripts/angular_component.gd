extends Node2D


func _ready() -> void:
	main_ui.connect("start_battle", start_battle)

func start_battle():
	var parent = get_parent()
	if parent is RigidBody2D:
		print("torque")
		parent.add_constant_torque(1000000)
