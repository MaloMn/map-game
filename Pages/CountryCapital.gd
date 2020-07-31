extends Control

var question = ""
var solution = ""
var choices = []

var active_button_name = ""
var button = preload("res://Objects/ChoiceButton.tscn")


func _ready() -> void:
	pass


func init(shortname, start=PageSwitcher.random_int(0, 1)):
	var line = DataLoader.get_line_of_short(shortname)
	# Setting question and answer
	if start == 0:
		question = line[0]
		solution = line[2]
		choices = DataLoader.get_random_names('Capital', solution, 4)
	else:
		question = line[2]
		solution = line[0]
		choices = DataLoader.get_random_names('Country', solution, 4)
		
	print(question, ' ', solution, ' ', choices)

	# Setting the title
	get_node("Capital").text = question
	get_node("MultipleChoice").init(self, choices, solution)
