extends HBoxContainer
class_name Inventory

var spawn_controller: SpawnController

@export var part_button_scene: PackedScene


func _ready() -> void:
	call_deferred("initial_generation")

func initial_generation():
	$ReserveParts.add_child(generate_new_part_button())
	$ReserveParts.add_child(generate_new_part_button())
	$ReserveParts.add_child(generate_new_part_button())
	$ReserveParts.add_child(generate_new_part_button())

func reset_level():
	spawn_controller.reset_level()
	for b in $ActiveParts.get_children():
		if b is PartButton:
			spawn_controller.spawn_limb(b.part_id, b.spawn_slot, b.target_position, b)
	
	$ReserveParts.add_child(generate_new_part_button())
	$ReserveParts.add_child(generate_new_part_button())
	


func generate_new_part_button():
	var part_button = part_button_scene.instantiate()
	part_button.connect("part_button_pressed", _on_part_button_pressed)
	part_button.part_id = randi_range(1, spawn_controller.limb_scenes.size() - 1)
	part_button.text = str(part_button.part_id)
	return part_button
	


func _on_part_button_pressed(button: PartButton) -> void:
	var parent = button.get_parent()
	var make_active = false
	if parent == $ReserveParts:
		make_active = true
	if $ActiveParts.get_child_count() > spawn_controller.slot_count:
		make_active = false
	
	parent.remove_child(button)
	
	if make_active:
		$ActiveParts.add_child(button)
		var slot = spawn_controller.fill_limb_slot(button.part_id, button.target_position, button)
		button.spawn_slot = slot
	else:
		spawn_controller.remove_limb(button.spawn_slot)
		button.spawn_slot = -1
		$ReserveParts.add_child(button)
		
		
