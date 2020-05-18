extends Node


# var a: int = 2
# var b: String = "text"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$StartScreen.connect("start_game", self, "_on_start_game")
	


func _on_start_game(cap2coun, coun2cap, counmap, capmap, flag2coun):
	print("starting!")
	pass
