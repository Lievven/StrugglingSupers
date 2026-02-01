extends PinJoint2D
class_name DragJoint

signal drag_and_drop

@export var base_target: BasePart
@export var is_player: bool = true
@export var physics_force: float = 50000
@onready var drag_handle = $CharacterBody2D
var on_handle = true

var attached_button: PartButton = null

func drag_part(pos: Vector2):
	position = pos
	attached_button.target_position = pos

func _ready() -> void:
	main_ui.connect("start_battle", start_battle)
	if not is_player:
		$CharacterBody2D.visible = false

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	self.emit_signal("drag_and_drop", event, self)


func swap_target():
	if on_handle:
		node_a = base_target.get_path()
		on_handle = false
		$CharacterBody2D.visible = false
	else:
		$CharacterBody2D.visible = true
		$CharacterBody2D.position = position
		node_a = drag_handle.get_path()
		on_handle = true


func swap_limb(limb: CollisionObject2D):
	node_b = limb.get_path()


func start_battle():
	swap_target()
