extends Area2D

#export (Color, RGB) var mouse_out
#export (Color, RGB) var mouse_over
var mouse_out = Colors.CITY
var mouse_over = Colors.CITY_OVER
var color = Color(1.0, 1.0, 1.0)

var poly_pts = []
var circle_disp = []
var center = Vector2(0, 0)
var radius = 0

var _on_city = false


func _draw():
	draw_polygon(circle_disp, PoolColorArray([color]))
#	draw_circle(center, radius, color)


func init(pts_center):
	self.connect("mouse_entered", self, "_on_Area2D_mouse_entered")
	self.connect("mouse_exited", self, "_on_Area2D_mouse_exited")
	set_modulate(mouse_out)
	
	# Coordinates of city pinpoint
	center = Vector2(pts_center[0], pts_center[1])
	radius = 1
	circle_disp = _circle(center, radius, 4)
	
	var circle_coll = _circle(center, radius * 2, 10)
	var collision = CollisionPolygon2D.new()
	collision.set_name("CollisionCircle")
	add_child(collision)
	collision.set_polygon(circle_coll)


func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("left_click") and _on_city:
		get_parent().check_answer(self.name.replace('_city', ''))
		print(self.name.replace('_city', ''))


func _on_Area2D_mouse_entered() -> void:
	if !get_parent()._clicked:
		set_modulate(mouse_over)
		_on_city = true


func _on_Area2D_mouse_exited() -> void:
	if !get_parent()._clicked:
		set_modulate(mouse_out)
		_on_city = false


func _circle(c, r, nb_pts):
	var points = PoolVector2Array()
	for i in range(nb_pts):
		var radian = i*2*PI/nb_pts
		var pts = Vector2(cos(radian), sin(radian))*r + c
		points.push_back(pts)
	return points
