extends Control

onready var multiple = get_node("MultipleChoice")
onready var flag = get_node("Flag")

var flag_path = ""
var solution = ""
var choices = []

var active_button_name = ""
var button = preload("res://Objects/ChoiceButton.tscn")

var margin = 10.0
var ratio = 0.3


func _ready() -> void:
	multiple.add_constant_override("hseparation", margin)
	multiple.add_constant_override("vseparation", margin) 


func _physics_process(delta: float) -> void:
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
		multiple.rect_size = Vector2(winsize[0] - 2*margin, ratio*winsize[1] - margin)
		multiple.rect_position = Vector2(margin, (1-ratio)*winsize[1])


func init(data):
	# Setting question and answer
	flag_path = load("res://data/flag/" + data[1])
	solution = data[0]
	choices = DataLoader.get_random_names('Country', solution, 4)

	print(flag_path, ' ', solution, ' ', choices)

	# Setting the title
	get_node("Flag").texture = flag_path
	# Setting the multiple choices
	get_node("MultipleChoice").init(self, choices, solution)
