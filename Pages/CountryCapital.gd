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
		choices = get_random_names('Capital', solution, 4)
	else:
		question = data[1]
		solution = data[0]
		choices = get_random_names('Country', solution, 4)
		
	print(question, ' ', solution, ' ', choices)

	# Setting the title
	get_node("Capital").text = question

	# Setting the options
	for i in range(len(choices)):
		# Create button and set its object name
		var b = button.instance()
		var name = "Choice" + str(i)
		b.name = name
		# Set label text of button
		b.init(choices[i])
		# Connecting the mouse inputs
		b.connect('mouse_entered', self, '_on_mouse_entered', [choices[i]])
		b.connect('mouse_exited', self, '_on_mouse_exited')

		get_node("MultipleChoice/GridContainer").add_child(b)

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
