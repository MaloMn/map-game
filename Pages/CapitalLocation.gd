extends Node2D

var obj_country = preload("res://Objects/Country.tscn")
var obj_city = preload("res://Objects/City.tscn")

var _shortname = ""
var _capital = ""
var _clicked = false

var timeout = 3.0  # in seconds

func _ready() -> void:
	# Drawing the world map without interactivity
	var poly = []
	for country in DataLoader.polygons.keys():
		poly = DataLoader.polygons[country]
		if len(poly) >= 2:
			var a = obj_country.instance()
			a.init(_country(poly[0]), [])
			a.set_name(country)
			add_child(a)

	# Drawing the cities with interactivity
	var pin = []
	for city in DataLoader.pinpoints.keys():
		pin = DataLoader.pinpoints[city]
#		pin = [pin[1], pin[0]]
		if len(pin) == 2:
			var c = obj_city.instance()
			c.init(pin)
			c.set_name(city + "_city")
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
	_shortname = shortname
	var line = DataLoader.get_line_of_short(_shortname)
	_capital = line[2]
	# TODO: add line[3] for the subtext
	get_node("CanvasLayer/PanelContainer/Label").text = _capital


func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("ui_accept") and _clicked:
		PageSwitcher.next_level()


func check_answer(a_shortname):
	_clicked = true

	# Coloring the answer and/or the solution
	get_node(_shortname + "_city").set_modulate(Colors.COUNTRY_GOOD)
	if a_shortname != _shortname:
		get_node(a_shortname + "_city").set_modulate(Colors.COUNTRY_BAD)

	$"Camera2D".animate_wrong_answer(get_node(_shortname + "_city").center, timeout)
