extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func init(name):
	get_node("CenterContainer/HBoxContainer/Label").text = name
