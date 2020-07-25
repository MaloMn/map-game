extends Node2D

onready var data = $"/root/DataLoader"
onready var switcher = $"/root/PageSwitcher"
var obj_area = preload("res://Objects/Area2D.tscn")

var question = ""


func _ready() -> void:
	var poly = []
	for country in data.polygons.keys():
		poly = data.polygons[country]
		if len(poly) == 2:
			var a = obj_area.instance()
			a.init(_country(poly[0]), _country(poly[1]))
			a.set_name(country)
			add_child(a)


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
	
	
func init(data):
	question = data[0]
	get_node("CanvasLayer/PanelContainer/Label").text = question


func check_answer(answer):
	if question.to_lower() == answer.to_lower():
		print("Yep, it was ", question)
		switcher.next_level()
