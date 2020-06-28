extends Area2D


export (Color, RGB) var mouse_out
export (Color, RGB) var mouse_over

var color = PoolColorArray([Color(1.0, 1.0, 1.0)])
var poly_pts = []
var collision = CollisionPolygon2D.new()


func _draw():
	for p in poly_pts:
		draw_polygon(p, color)


func init(pts_draw, pts_coll):
	self.connect("mouse_entered", self, "_on_Area2D_mouse_entered")
	self.connect("mouse_exited", self, "_on_Area2D_mouse_exited")
	set_modulate(mouse_out)
	poly_pts = pts_draw
	for i in range(len(pts_coll)):
		var collision = CollisionPolygon2D.new()
		collision.set_name(str(i))
		add_child(collision)
		collision.set_polygon(pts_coll[i])


func _on_Area2D_mouse_entered() -> void:
	set_modulate(mouse_over)


func _on_Area2D_mouse_exited() -> void:
	set_modulate(mouse_out)
