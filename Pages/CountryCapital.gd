extends Control

var question = ""
var solution = ""
var choices = []

var active_button_name = ""
var button = preload("res://Objects/ChoiceButton.tscn")


func _ready() -> void:
	pass # Replace with function body.


func init(data, start=PageSwitcher.random_int(0, 1)):
	# Setting question and answer
	if start == 0:
		question = data[0]
		solution = data[1]
		choices = DataLoader.get_random_names('Capital', solution, 4)
	else:
		question = data[1]
		solution = data[0]
		choices = DataLoader.get_random_names('Country', solution, 4)
		
	print(question, ' ', solution, ' ', choices)

	# Setting the title
	get_node("Capital").text = question

	get_node("MultipleChoice").init(self, choices, solution)
