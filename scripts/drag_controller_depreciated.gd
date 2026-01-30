extends Node2D

@export var parts: Array[BasePart] = []

var draggable = null
var drag_handle = Vector2(0, 0)
var approach_force = 200

func _ready():
	for p in parts:
		p.connect("drag_and_drop", _on_part_input_event)


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
	draggable.position = get_viewport().get_mouse_position()
	return
	var target_position = get_viewport().get_mouse_position() - draggable.position
	draggable.constant_force = target_position * approach_force


func _freeze_all(freeze = true):
	for p in parts:
		p.freeze = freeze


func _on_part_input_event(event, shape):
	if not event is InputEventMouseButton:
		return
	if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		print("Turn Clockwise")
	if event.button_index == MOUSE_BUTTON_WHEEL_UP:
		print("Turn Anticlockwise")
		
	if event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			draggable = shape
			draggable.linear_damp_mode = RigidBody2D.DAMP_MODE_REPLACE
			draggable.linear_damp = 20
			drag_handle = event.position - shape.position
	
