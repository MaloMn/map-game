extends Area2D


var collision = CollisionPolygon2D.new()


func _ready() -> void:
	add_child(collision)


func init():
	var poly = get_parent().poly_points
	collision.set_polygon(poly)
