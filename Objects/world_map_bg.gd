extends Node2D

var polygons = []
var color = PoolColorArray([Colors.COUNTRY])


func _draw() -> void:
	for poly_pts in polygons:
		for p in poly_pts:
			draw_polygon(p, color)


func _ready() -> void:
	var poly = []
	for country in DataLoader.polygons.keys():
		poly = DataLoader.polygons[country]
		if len(poly) >= 2:
			polygons.append(_country(poly[0]))


func _country(poly):
	var country = []
	for p in poly:
		country.append(_polygon(p))
	return country


func _polygon(pts):
	var points = PoolVector2Array()
	for i in range(0, len(pts)):
		points.push_back(Vector2(pts[i][0], pts[i][1]))
	return points
	
	
func init(shortname):
	pass


func color_country(_country, _color):
	polygons = [DataLoader.polygons[_country][0]]
	color = PoolColorArray([_color])
	update()
