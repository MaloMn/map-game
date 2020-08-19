extends Camera2D

const MAX_ZOOM_LEVEL = 0.05
var MIN_ZOOM_LEVEL = 1
const ZOOM_INCREMENT = 0.01
var _max_boundary = Vector2()

var map_width = 360.0
var map_height = 180.0

var _current_zoom_level = 1
var _boundary = Vector2()
var _drag = false


func _ready():
	_update_viewport()
	get_tree().get_root().connect("size_changed", self, "_update_viewport")


func _input(event):	
	if event.is_action_pressed("cam_drag"):
		_drag = true

	elif event.is_action_released("cam_drag"):
		_drag = false

	elif event.is_action("cam_zoom_in"):
#		print(get_viewport_transform(), get_viewport_rect())
		_update_zoom(-ZOOM_INCREMENT, get_local_mouse_position())

	elif event.is_action("cam_zoom_out"):
#		print(get_viewport_transform(), get_viewport_rect())
		_update_zoom(ZOOM_INCREMENT, get_local_mouse_position())

	elif event is InputEventMouseMotion && _drag:
		_update_position(event.relative)
#		print(get_viewport_transform(),' ', get_viewport().size, ' ', _current_zoom_level)
#		set_offset(get_offset() - event.relative*_current_zoom_level)
#		print(self.offset)

#	print(get_offset())


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
	
	# Need to compute futur boundary and see if anything stands out
	# Computing futur boundary (according to newly computed _current_zoom_level)
	_compute_boundary()
	var futur_offset = get_offset() + zoom_center*ratio
	futur_offset = _correct_offset(futur_offset)
	
	# Need to correct the offset if it goes out of the map
	
	# Execution of the movements
	set_offset(futur_offset)
	set_zoom(Vector2(_current_zoom_level, _current_zoom_level))


func _update_position(relative):
	var new = get_offset() - relative*_current_zoom_level
	new = _correct_offset(new)
	set_offset(new)
	print(self.offset)


func _correct_offset(wanted_offset):
	var s = wanted_offset.sign()
	wanted_offset = wanted_offset.abs()
	wanted_offset = Vector2(min(_boundary[0], wanted_offset[0]), min(_boundary[1], wanted_offset[1]))
	return wanted_offset * s


func _update_viewport():
	var size = get_viewport().size
	MIN_ZOOM_LEVEL = min(map_width/float(size[0]), map_height/float(size[1]))
	
	# Actual zooming action 
	var start_zoom_increment = min(map_width/size[0], map_height/size[1]) - _current_zoom_level
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
		
