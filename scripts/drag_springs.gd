extends CharacterBody2D
class_name DragSpring

signal drag_and_drop

@export var base_target: BasePart
@export var attached_target: RigidBody2D
var on_handle = true

var attached_button: PartButton = null

func drag_part(pos: Vector2):
	position = pos
	attached_button.target_position = pos


func _ready() -> void:
	$Spring1.node_a = attached_target.get_path()
	$Spring2.node_a = attached_target.get_path()
	$Spring3.node_a = attached_target.get_path()
	main_ui.connect("start_battle", start_battle)


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	self.emit_signal("drag_and_drop", event, self)


func swap_target():
	if on_handle:
		$AnimatedComponent.visible = false
		$CollisionShape2D.disabled = true
		$Spring1.node_b = base_target.get_path()
		$Spring2.node_b = base_target.get_path()
		$Spring3.node_b = base_target.get_path()
		on_handle = false
	else:
		return
		$CharacterBody2D.position = position
		$Spring1.node_b = get_path()
		$Spring2.node_b = get_path()
		$Spring3.node_b = get_path()
		on_handle = true


func swap_limb(limb: CollisionObject2D):
	$Spring1.node_a = limb.get_path()
	$Spring2.node_a = limb.get_path()
	$Spring3.node_a = limb.get_path()


func start_battle():
	swap_target()
