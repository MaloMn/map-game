extends Camera2D

const MAX_ZOOM_LEVEL = 0.03
var MIN_ZOOM_LEVEL = 1
const ZOOM_INCREMENT = 0.01
var _max_boundary = Vector2()

var map_width = 360.0
var map_height = 180.0
var size = null

var _current_zoom_level = 1
var _boundary = Vector2()
var _drag = false


func _ready():
	size = get_viewport().size
	_update_viewport()
	get_tree().get_root().connect("size_changed", self, "_update_viewport")


func _input(event):	
	if event.is_action_pressed("cam_drag"):
		_drag = true

	elif event.is_action_released("cam_drag"):
		_drag = false

	elif event.is_action("cam_zoom_in"):
		_update_zoom(-ZOOM_INCREMENT, get_local_mouse_position())

	elif event.is_action("cam_zoom_out"):
		_update_zoom(ZOOM_INCREMENT, get_local_mouse_position())

	elif event is InputEventMouseMotion && _drag:
		_update_position(event.relative)


func _update_zoom(incr, zoom_anchor):
	var old_zoom = _current_zoom_level
	_current_zoom_level += incr
	if _current_zoom_level < MAX_ZOOM_LEVEL:
		_current_zoom_level = MAX_ZOOM_LEVEL
	elif _current_zoom_level > MIN_ZOOM_LEVEL:
		_current_zoom_level = MIN_ZOOM_LEVEL
	if old_zoom == _current_zoom_level:
		return
	
	var zoom_center = zoom_anchor - get_offset()
	var ratio = 1 - _current_zoom_level/old_zoom
	
	# Computing futur boundary (according to newly computed _current_zoom_level)
	_compute_boundary()
	var futur_offset = get_offset() + zoom_center*ratio
	
	# Correcting the offset
	futur_offset = _correct_offset(futur_offset)
	
	# Execution of the movements
	set_offset(futur_offset)
	set_zoom(Vector2(_current_zoom_level, _current_zoom_level))


func _update_position(relative):
	var new = get_offset() - relative*_current_zoom_level
	new = _correct_offset(new)
	set_offset(new)


func _correct_offset(wanted_offset):
	var s = wanted_offset.sign()
	wanted_offset = wanted_offset.abs()
	wanted_offset = Vector2(min(_boundary[0], wanted_offset[0]), min(_boundary[1], wanted_offset[1]))
	return wanted_offset * s


func _update_viewport():
	size = get_viewport().size
	MIN_ZOOM_LEVEL = min(map_width/float(size[0]), map_height/float(size[1]))
	
	# Actual zooming action 
	var start_zoom_increment = MIN_ZOOM_LEVEL - _current_zoom_level
	_update_zoom(start_zoom_increment, Vector2(0, 0))
	
	# Setting of the variable that prevent moving out of the map
	var width_out = map_width - size[0] * MIN_ZOOM_LEVEL
	var height_out = map_height - size[1] * MIN_ZOOM_LEVEL
	_max_boundary = [width_out/2, height_out/2]
	_compute_boundary()


func _compute_boundary():
	var size = get_viewport().size
	var width_out = map_width - size[0] * _current_zoom_level
	var height_out = map_height - size[1] * _current_zoom_level
	_boundary = [width_out/2, height_out/2]
	if _boundary[0] < _max_boundary[0]:
		_boundary[0] = _max_boundary[0]
	if _boundary[1] < _max_boundary[1]:
		_boundary[1] = _max_boundary[1]


func animate_answer(box, time, margin=50):
	# Basically animate a path to the right country position 
	# from the current position
	if typeof(box) == 5:
		box = [box[1], box[0], box[1], box[0]]
	
	# Zooming onto the specified box
	var end_zoom = max((abs(box[1] - box[3]) + margin)/size[0], (abs(box[0] - box[2]) + margin)/size[1])
	_current_zoom_level = min(end_zoom, MIN_ZOOM_LEVEL)
	end_zoom = Vector2(_current_zoom_level, _current_zoom_level)
	
	# Spatial ending position
	_compute_boundary()
	var end_position = Vector2(((box[1] + box[3]) - map_width)/2, ((box[0] + box[2]) - map_height)/2)
	end_position = _correct_offset(end_position)
	
	# Move
	var tween = Tween.new()
	self.add_child(tween)
	tween.targeting_property(self, "offset", self, "offset", end_position, time, 0, 1)
	tween.targeting_property(self, "zoom", self, "zoom", end_zoom, time, 0, 1)
	tween.start()
