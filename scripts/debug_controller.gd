extends Node2D

@export var spawn_controller: SpawnController

var draggable = null
var drag_handle = Vector2(0, 0)
var approach_force = 200


func _physics_process(delta: float) -> void:
	if draggable:
		_drag_target()


func _unhandled_input(event):
	if event is InputEventMouseButton \
	and not event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and draggable:
		draggable.constant_force = Vector2(0, 0)
		draggable.linear_damp_mode = RigidBody2D.DAMP_MODE_COMBINE
		draggable.linear_damp = 1.0
		draggable = null
		return


func _drag_target():
	var target_position = get_viewport().get_mouse_position() - draggable.position
	draggable.constant_force = target_position * approach_force


func _on_part_input_event(viewport, event, shape_idx):
	if not event is InputEventMouseButton:
		return
		
	if event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			draggable = spawn_controller.parent_body
			draggable.linear_damp_mode = RigidBody2D.DAMP_MODE_REPLACE
			draggable.linear_damp = 20
			drag_handle = event.position - spawn_controller.parent_body.position
