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
	choices = get_random_names('Country', solution, 4)

	print(flag_path, ' ', solution, ' ', choices)

	# Setting the title
	get_node("Flag").texture = flag_path

	# Setting the options
	for i in range(len(choices)):
		# Create button and set its object name
		var b = get_node("MultipleChoice/Choice" + str(i))
		# Set label text of button
		b.init(choices[i])
		# Reset min_rect_size
		b.rect_min_size = Vector2(0.0, 0.0)
		# Connecting the mouse inputs
		b.connect('mouse_entered', self, '_on_mouse_entered', [choices[i]])
		b.connect('mouse_exited', self, '_on_mouse_exited')

# Connecting the Inline response
#	var n = get_node("Inline/LineEdit")
#	n.connect("text_entered", self, "_on_submit")


func get_random_names(column_name, value, nb):
	print(column_name, value, nb)
	var all_names = DataLoader.column(column_name)
	all_names.erase(value)
	
	var names_choices = [value]
	for i in range(nb - 1):
		var selection = all_names[PageSwitcher.random_int(0, len(all_names) - 1)]
		names_choices.append(selection)
		all_names.erase(selection)

	return names_choices
	

func _input(event: InputEvent) -> void:
	# Handle click on button
	if event is InputEventMouseButton and active_button_name != "" and event.pressed:
		_on_submit(active_button_name)


#func _on_MultipleChoice_button_up() -> void:
#	get_node("Inline").visible = false
#	get_node("MultipleChoice").visible = true


func _on_submit(text):
	if text == solution:
		
		PageSwitcher.next_level()
	else:
		print('Nope.')


func _on_mouse_entered(button_name):
	active_button_name = button_name


func _on_mouse_exited():
	active_button_name = ""
