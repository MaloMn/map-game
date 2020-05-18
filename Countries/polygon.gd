extends Node2D

export (Color, RGB) var mouse_out
export (Color, RGB) var mouse_over
var colors = null
var poly_points = null


func init(country_pts):
	set_modulate(mouse_out)
	# Set the values for drawing
	for pts in country_pts:
		poly_points = polygon(pts)
		colors = PoolColorArray([Color(1.0, 1.0, 1.0)])
		# Initiate the collision shape
		get_child(0).init()


func _ready() -> void:
#	init('square', Vector2(200, 200), 300)
	pass


func _draw():
	draw_polygon(poly_points, colors)


#func _process(delta):	
#	update()


func polygon(pts):
	var points = PoolVector2Array()
#	for i in range(0, len(pts), 2):
#		points.push_back(Vector2(pts[i], pts[i+1]))
	for i in range(0, len(pts)):
		points.push_back(Vector2(pts[i][0], pts[i][1]))
	return points


func _on_Area2D_mouse_entered() -> void:
	set_modulate(mouse_over)


func _on_Area2D_mouse_exited() -> void:
	set_modulate(mouse_out)
