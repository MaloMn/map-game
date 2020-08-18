extends Area2D

var _mouse_out = Colors.COUNTRY
var _mouse_over = Colors.COUNTRY_MOUSE_OVER

var color = PoolColorArray([Color(1.0, 1.0, 1.0)])
var poly_pts = []
var collision = CollisionPolygon2D.new()
var _on_country = false


func _ready():
	VisualServer.set_default_clear_color(Colors.BG)


func _draw():
	for p in poly_pts:
		draw_polygon(p, color)
#	draw_circle(Vector2(285.6686719, 100.4266648), 10, _mouse_over)
#	draw_circle(Vector2(360,180), 10, _mouse_over)


func init(pts_draw, pts_coll):
	self.connect("mouse_entered", self, "_on_Area2D_mouse_entered")
	self.connect("mouse_exited", self, "_on_Area2D_mouse_exited")
	set_modulate(_mouse_out)
	poly_pts = pts_draw
	for i in range(len(pts_coll)):
		var collision = CollisionPolygon2D.new()
		collision.set_name(str(i))
		add_child(collision)
		collision.set_polygon(pts_coll[i])


func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("left_click") and _on_country and !get_parent()._clicked:
		get_parent().check_answer(self.name)


func _on_Area2D_mouse_entered() -> void:
	if !get_parent()._clicked:
		set_modulate(_mouse_over)
		_on_country = true


func _on_Area2D_mouse_exited() -> void:
	if !get_parent()._clicked:
		set_modulate(_mouse_out)
		_on_country = false
