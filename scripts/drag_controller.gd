extends Node2D

@export var parts: Array[DragJoint] = []

var draggable = null

func _ready():
	for p in parts:
		p.connect("drag_and_drop", _on_part_input_event)



func _physics_process(delta: float) -> void:
	if draggable:
		draggable.position = get_viewport().get_mouse_position()


func _unhandled_input(event):
	if event is InputEventMouseButton \
	and not event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and draggable:
		draggable = null
		return


func _on_part_input_event(event, shape):
	if not event is InputEventMouseButton:
		return
		
	if event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			draggable = shape
	
