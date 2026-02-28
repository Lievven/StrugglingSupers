extends Node2D
class_name SpawnController

@export var limb_scenes: Array[PackedScene]
@export var parent_body: BasePart
@export var drag_controller: DragController
@export var slot_count: int = 5

var slots = []


func _ready():
	main_ui.inventory.spawn_controller = self
	main_ui.connect("debug_spawn", debug_spawn)
	main_ui.connect("start_battle", start_battle)
	for i in range(slot_count):
		slots.append(null)
	
	call_deferred("reset_level")


func reset_level():
	spawn_base(0, Vector2(300, 150))
	

func debug_spawn():
	spawn_limb(1, 1, Vector2(100, 100), null)
	spawn_limb(1, 2, Vector2(500, 100), null)
	#spawn_limb(3, 3, Vector2(200, 200))
	#spawn_limb(3, 4, Vector2(400, 200))
	spawn_limb(4, 0, Vector2(400, 200), null)


func start_battle():
	parent_body.input_pickable = true
	parent_body.connect("input_event", $DebugController._on_part_input_event)


func spawn_base(limb_id, pos):
	if parent_body:
		parent_body.queue_free()
	parent_body = limb_scenes[limb_id].instantiate()
	parent_body.position = pos
	parent_body.freeze = true
	
	get_parent().add_child(parent_body)
	

func remove_limb(slot_id: int):
	if slot_id < 0 or slot_id >= slots.size():
		return
	var limb = slots[slot_id]
	limb.queue_free()
	slots[slot_id] = null
	

func fill_limb_slot(limb_id: int, pos: Vector2, button, instant_drag: bool = false):
	for i in range(slots.size()):
		if not slots[i] == null:
			continue
		spawn_limb(limb_id, i, pos, button)
		if instant_drag:
			drag_controller.set_draggable(slots[i])
		return i
	
	return -1


func spawn_limb(limb_id: int, slot_id: int, pos: Vector2, button: PartButton):
	var slot = slots[slot_id]
	if  slot is Node2D:
		slot.queue_free()
	
	var new_limb = limb_scenes[limb_id].instantiate()
	if new_limb is DragJoint or new_limb is DragSpring:
		new_limb.base_target = parent_body
	new_limb.position = pos
	
	new_limb.attached_button = button
	slots[slot_id] = new_limb
	drag_controller.add_part(new_limb)
	get_parent().add_child(new_limb)
