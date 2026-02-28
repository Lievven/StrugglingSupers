extends Button
class_name PartButton

signal part_button_pressed(button: PartButton)

@export var text_label: PackedScene
@export var part_id: int = 1


var target_position = Vector2(randi_range(250, 350), randi_range(100, 300))
var spawn_slot = -1

var drag_mode = false
var is_hovered = false


func _make_custom_tooltip(label_text):
	var label = text_label.instantiate()
	label.text = label_text
	return label


func _on_pressed() -> void:
	drag_mode = false
	emit_signal("part_button_pressed", self, false)


func _on_button_down() -> void:
	drag_mode = true


func _on_mouse_exited() -> void:
	is_hovered = false
	if drag_mode:
		target_position = get_viewport().get_mouse_position()
		emit_signal("part_button_pressed", self, true)
		drag_mode = false
		

func _on_mouse_entered() -> void:
	is_hovered = true
