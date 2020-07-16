extends Node2D

onready var data = $"/root/DataLoader"
var obj_area = preload("res://Objects/Area2D.tscn")


func _ready() -> void:
	var poly = []
	for country in data.polygons.keys():
		poly = data.polygons[country]
		if len(poly) == 2:
			var a = obj_area.instance()
			a.init(country(poly[0]), country(poly[1]))
			a.set_name(country)
			add_child(a)


func country(poly):
	var country = []
	for p in poly:
		country.append(polygon(p))
	return country


func polygon(pts):
	var points = PoolVector2Array()
	for i in range(0, len(pts)):
		points.push_back(Vector2(pts[i][0], pts[i][1]))
	return points
