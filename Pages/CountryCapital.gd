extends Control

var question = ""
var solution = ""
var choices = []


func _ready() -> void:
	pass # Replace with function body.


func init(data, start=PageSwitcher.random_int(0, 1)):
	# Setting question and answer
	if start == 0:
		question = data[0]
		solution = data[1]
		choices = get_random_names('Capital', solution, 4)
	else:
		question = data[1]
		solution = data[0]
		choices = get_random_names('Country', solution, 4)
		
	print(question, solution, choices)

	# Setting the title
	get_node("Capital").text = question

	# Setting the options
	for i in range(1, 5):
		var b = get_node("MultipleChoice/Choices/Choice" + str(i))
		b.text = choices[i-1]
		b.name = choices[i-1]
		# Connecting the buttons
		b.connect('button_up', self, "_on_submit", [b.text])
		
	# Connecting the Inline response
	var n = get_node("Inline/LineEdit")
	n.connect("text_entered", self, "_on_submit")


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
	

func _on_MultipleChoice_button_up() -> void:
	get_node("Inline").visible = false
	get_node("MultipleChoice").visible = true

# TODO REPLACE THIS
func _on_submit(text):
	if text == solution:
		PageSwitcher.next_level()
	else:
		print('Nope.')
