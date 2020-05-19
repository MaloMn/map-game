extends Node2D


func _ready() -> void:
	pass


func _on_mouse_entered() -> void:
	for child in get_children():
		child.self_modulate = Color(0.5, 0.5, 1)


func _on_mouse_exited() -> void:
	for child in get_children():
		child.self_modulate = Color(1, 1, 1)
