extends Area2D

#export (Color, RGB) var mouse_out
#export (Color, RGB) var mouse_over
var mouse_out = Color(0.0, 0.0, 0.0)
var mouse_over = Color(0.0, 1.0, 0.0)

var color = PoolColorArray([Color(1.0, 1.0, 1.0)])
var poly_pts = []
var _on_country = false


func _draw():
	draw_polygon(poly_pts, color)


func init(pts_center):
	self.connect("mouse_entered", self, "_on_Area2D_mouse_entered")
	self.connect("mouse_exited", self, "_on_Area2D_mouse_exited")
	set_modulate(mouse_out)
	
	# Coordinates of city pinpoint
	poly_pts = _circle(pts_center, 10)
	var circle_coll = _circle(pts_center, 30)
	
	var collision = CollisionPolygon2D.new()
	collision.set_name("CollisionCircle")
	add_child(collision)
	collision.set_polygon(circle_coll)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and _on_country:
		get_parent().check_answer(self.name)


func _on_Area2D_mouse_entered() -> void:
	set_modulate(mouse_over)
	_on_country = true


func _on_Area2D_mouse_exited() -> void:
	set_modulate(mouse_out)
	_on_country = false


func _circle(center, radius, error=0.5):
	var points = PoolVector2Array()
	for i in range(0, 2*PI, error):
		points.push_back(Vector2(center[0] + cos(i), center[1] + sin(i)) * radius)
	return points
