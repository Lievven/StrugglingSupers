extends Button
class_name PartButton

signal part_button_pressed(button: PartButton)

@export var part_id: int = 1
var target_position = Vector2(randi_range(100, 300), randi_range(100, 300))

var spawn_slot = -1

func _on_pressed() -> void:
	emit_signal("part_button_pressed", self)
