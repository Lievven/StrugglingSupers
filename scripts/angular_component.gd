extends Node2D

@export var angular_parent: Joint2D

func _ready() -> void:
	main_ui.connect("start_battle", start_battle)

func start_battle():
	var parent = get_parent()
	if parent is RigidBody2D:
		parent.add_constant_torque(angular_parent.physics_force)
