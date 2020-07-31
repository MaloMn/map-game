extends Node2D

onready var data = $"/root/DataLoader"
onready var switcher = $"/root/PageSwitcher"
var obj_area = preload("res://Objects/Area2D.tscn")
var obj_city = preload("res://Objects/City.tscn")

var question = ""


func _ready() -> void:
	var poly = []
	for country in data.polygons.keys():
		poly = data.polygons[country]
		if len(poly) >= 3:
			var a = obj_area.instance()
			a.init(_country(poly[0]), [])
			a.set_name(country)
			add_child(a)
			
			var c = obj_city.instance()
			c.init(poly[2])
			c.set_name(country + "_city")
			add_child(c)


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
	var line = data.get_line_of_short(shortname)
	question = line[2]
	# TODO: add line[3] for the subtext
	get_node("CanvasLayer/PanelContainer/Label").text = question


func check_answer(answer):
	if question.to_lower() == answer.to_lower():
		print("Yep, it was ", question)
		switcher.next_level()
