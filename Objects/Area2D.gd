extends Area2D


var poly_pts = []
var color = PoolColorArray([Color(1.0, 1.0, 1.0)])

var collision = CollisionPolygon2D.new()


func _draw():
	draw_polygon(poly_pts, color)


func init(pts):
	add_child(collision)
	collision.set_polygon(pts)
	poly_pts = pts
