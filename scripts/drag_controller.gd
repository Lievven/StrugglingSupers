extends Node2D
class_name DragController

@export var parts: Array[DragJoint] = []
@export var springs: Array[DragSpring] = []

var draggable = null
var pickup_spot = null

func _ready():
	for p in parts:
		p.connect("drag_and_drop", _on_part_input_event)
	for s in springs:
		s.connect("drag_and_drop", _on_part_input_event)
		


func add_part(part):
	if part is DragJoint:
		parts.append(part)
	elif part is DragSpring:
		springs.append(part)
	part.connect("drag_and_drop", _on_part_input_event)


func _physics_process(delta: float) -> void:
	if draggable:
		draggable.drag_part(get_viewport().get_mouse_position())


func _unhandled_input(event):
	if event is InputEventMouseButton \
	and not event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and draggable:
		if main_ui.inventory.get_global_rect().has_point(event.position):
			draggable.drag_part(pickup_spot)
			if draggable.attached_button:
				draggable.attached_button._on_pressed()
		draggable = null


func _on_part_input_event(event, shape):
	if not event is InputEventMouseButton:
		return
		
	if event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			set_draggable(shape)


func set_draggable(shape):
			draggable = shape
			pickup_spot = draggable.position
