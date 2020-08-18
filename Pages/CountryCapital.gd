extends Control

var question = ""
var solution = ""
var choices = []

var active_button_name = ""
var button = preload("res://Objects/ChoiceButton.tscn")

var text_info_answer = ""


func _ready() -> void:
	get_tree().get_root().connect("size_changed", self, "_update_viewport")
	_update_viewport()
	
	get_node("VBoxContainer/MultipleChoice").connect("clicked", self, "clicked")


func init(shortname, start=PageSwitcher.random_int(0, 1)):
	var line = DataLoader.get_line_of_short(shortname)
	var is_question_country = true
	# Setting question and answer
	if start == 0:
		question = line[0]
		solution = line[2]
		choices = DataLoader.get_random_names('Capital', solution, 4)
		is_question_country = true
	else:
		question = line[2]
		solution = line[0]
		choices = DataLoader.get_random_names('Country', solution, 4)
		is_question_country = false
		
	print(question, ' ', solution, ' ', choices)

	# Setting the texts
	get_node("VBoxContainer/Capital").text = question
	var indication = get_node("VBoxContainer/Indication")
	var q_index = -1
	var a_index = -1
	if is_question_country:
		q_index = 1
		a_index = 3
		indication.text = "HAS FOR CAPITAL"
	else:
		q_index = 3
		a_index = 1
		indication.text = "IS THE CAPITAL OF"

	# Setting the RichTextLabels
	var q = get_node("VBoxContainer/InfoTitle")
	if line[q_index] != "":
		q.bbcode_text = "[center]" + line[q_index] + "[/center]"
	else:
		q.queue_free()

	get_node("VBoxContainer/MultipleChoice").init(self, choices, solution)
	var info_answer = get_node("VBoxContainer/InfoAnswer")
	info_answer.bbcode_text = ""
	text_info_answer = line[a_index]


func clicked():
	var info_answer = get_node("VBoxContainer/InfoAnswer")
	info_answer.bbcode_text = "[center]" + text_info_answer + "[/center]"


func _update_viewport():
	var container = get_node("VBoxContainer")
	if container.rect_size[0] + 40 > OS.window_size[0]:
		container.rect_size[0] = OS.window_size[0] - 40
		container.rect_position = Vector2(20, 0)
