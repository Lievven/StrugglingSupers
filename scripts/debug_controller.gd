extends Node2D

@export var spawn_controller: SpawnController

@export var max_drag_time: float = 1.0
@export var drag_reload_factor: float = 0.2
@onready var drag_time = max_drag_time
var can_drag = true

var draggable = null
var drag_handle = Vector2(0, 0)
var approach_force = 200


func _physics_process(delta: float) -> void:
	_drag_target(delta)


func _unhandled_input(event):
	if event is InputEventMouseButton \
	and not event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:
		_end_drag()


func _end_drag():
	if not draggable:
		return
		
	draggable.constant_force = Vector2(0, 0)
	draggable.linear_damp_mode = RigidBody2D.DAMP_MODE_COMBINE
	draggable.linear_damp = 1.0
	draggable = null


func _drag_target(delta: float):
	if not can_drag or not draggable:
		drag_time += delta * drag_reload_factor
		if drag_time >= max_drag_time:
			drag_time = max_drag_time
		if drag_time >= max_drag_time / 2.0:
			can_drag = true
		return
	
	var target_position = get_viewport().get_mouse_position() - draggable.position
	draggable.constant_force = target_position * approach_force
	
	drag_time -= delta
	if drag_time < 0:
		can_drag = false
		_end_drag()


func _on_part_input_event(viewport, event, shape_idx):
	if not event is InputEventMouseButton:
		return
		
	if event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and can_drag:
			draggable = spawn_controller.parent_body
			draggable.linear_damp_mode = RigidBody2D.DAMP_MODE_REPLACE
			draggable.linear_damp = 20
			drag_handle = event.position - spawn_controller.parent_body.position
