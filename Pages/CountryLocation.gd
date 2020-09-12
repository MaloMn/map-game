extends Node2D

var obj_area = preload("res://Objects/Country.tscn")

var question = ""
var _shortname = ""
var _clicked = false

var timeout = 2.0  # in seconds

func _ready() -> void:
	var poly = []
	for country in DataLoader.polygons.keys():
#		print(country)
		poly = DataLoader.polygons[country]
		if len(poly) >= 2:
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
	
	
func init(shortname):
	var line = DataLoader.get_line_of_short(shortname)
	_shortname = shortname
	question = line[0]
	print(line, _shortname, question)
	get_node("CanvasLayer/PanelContainer/Label").text = question


func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("ui_accept") and _clicked:
		PageSwitcher.next_level()


func check_answer(a_shortname):
	_clicked = true

	# Coloring the answer and/or the solution
	get_node(_shortname).set_modulate(Colors.COUNTRY_GOOD)
	if a_shortname != _shortname:
		get_node(a_shortname).set_modulate(Colors.COUNTRY_BAD)

	$"Camera2D".animate_answer(get_node(_shortname).bounding_box(), timeout)
