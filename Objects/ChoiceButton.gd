extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func init(name):
	get_node("CenterContainer/HBoxContainer/Label").text = name


func right():
	get_node("CenterContainer/HBoxContainer/Box").texture = preload('res://sources/checkboxes/right.png')
	get_node("CenterContainer/HBoxContainer/Label").add_color_override("font_color", Colors.GOOD_TEXT)


func wrong():
	get_node("CenterContainer/HBoxContainer/Box").texture = preload('res://sources/checkboxes/wrong.png')
	get_node("CenterContainer/HBoxContainer/Label").add_color_override("font_color", Colors.BAD_TEXT)
