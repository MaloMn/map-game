extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_mouse_entered() -> void:
	for child in get_children():
		child.self_modulate = Color(0.5, 0.5, 1)


func _on_mouse_exited() -> void:
	for child in get_children():
		child.self_modulate = Color(1, 1, 1)
