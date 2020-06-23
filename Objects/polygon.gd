extends Node2D

export (Color, RGB) var mouse_out
export (Color, RGB) var mouse_over

var area = preload("res://Objects//Area2D.tscn")
var _selected = false


func init(country_pts):
	set_modulate(mouse_out)
	for pts in country_pts:
		# Add an area2D for the shape
		var a = area.instance()
		a.init(polygon(pts))
		a.connect("mouse_entered", self, "_on_Area2D_mouse_entered")
		a.connect("mouse_exited", self, "_on_Area2D_mouse_exited")
		add_child(a)


func _ready() -> void:
	pass


func polygon(pts):
	var points = PoolVector2Array()
	for i in range(0, len(pts)):
		points.push_back(Vector2(pts[i][0], pts[i][1]))
	return points


func _input(event):
	if event.is_action("click") and _selected:
		print(self.name)
		_selected = false
		# TODO make a link to master script to tell him to check the answer
		pass


func _on_Area2D_mouse_entered() -> void:
	set_modulate(mouse_over)
	_selected = true


func _on_Area2D_mouse_exited() -> void:
	set_modulate(mouse_out)
	_selected = false
