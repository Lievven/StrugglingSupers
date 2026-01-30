extends PinJoint2D
class_name DragJoint

signal drag_and_drop

@export var base_target: BasePart
@onready var drag_handle = $CharacterBody2D
var on_handle = true

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	self.emit_signal("drag_and_drop", event, self)


func swap_target():
	if on_handle:
		node_a = base_target.get_path()
		on_handle = false
	else:
		node_a = drag_handle.get_path()
		on_handle = true


func swap_limb(limb: CollisionObject2D):
	node_b = limb.get_path()
	
