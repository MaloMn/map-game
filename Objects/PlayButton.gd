extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_button_up() -> void:
	var a = get_parent().get_node("Options/CheckBox").is_pressed()
	var b = get_parent().get_node("Options/CheckBox2").is_pressed()
	var c = get_parent().get_node("Options/CheckBox3").is_pressed()
	print(a, b, c)
	SceneSwitcher.start_game([a, b, c])
