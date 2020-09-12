extends Control

onready var multiple = get_node("MultipleChoice")
onready var flag = get_node("Flag")

var flag_path = ""
var solution = ""
var choices = []

var active_button_name = ""
var _is_clicked = false
var button = preload("res://Objects/ChoiceButton.tscn")

var margin = 10.0
var ratio = 0.3


func _ready() -> void:
	get_tree().get_root().connect("size_changed", self, "_update_viewport")
	_update_viewport()
	
	get_node("MultipleChoice").connect("clicked", self, "_clicked")
	
	multiple.add_constant_override("hseparation", margin)
	multiple.add_constant_override("vseparation", margin) 


func init(shortname):
	# Setting question and answer
	var line = DataLoader.get_line_of_short(shortname)
	flag_path = DataLoader.flags[shortname]
	print(flag_path)
	solution = line[0]
	choices = DataLoader.get_random_names('Country', solution, 4)

	print(flag_path, ' ', solution, ' ', choices)

	# Setting the title
	get_node("Flag").texture = flag_path
	# Setting the multiple choices
	get_node("MultipleChoice").init(self, choices, solution)


func _update_viewport():
	# Setting the size of the objects responsively
	if typeof(flag_path) != TYPE_STRING:
		# Window size
		var winsize = OS.window_size
		var imsize = flag_path.get_size()

		# Flag position and size
		var height = (1-ratio)*winsize[1] - 2*margin
		var width = height*imsize[0]/imsize[1]
		flag.rect_size = Vector2(width, height)
		flag.rect_position = Vector2((winsize[0] - width)/2, margin)

		# MultipleChoice position and size
		multiple.rect_size = Vector2(width, ratio*winsize[1] - margin)
		multiple.rect_position = Vector2((winsize[0] - width)/2, (1-ratio)*winsize[1])


func _clicked():
	_is_clicked = true


func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("ui_accept") and _is_clicked:
		PageSwitcher.next_level()
 
