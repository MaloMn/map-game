extends Control

onready var switcher = $"/root/SceneSwitcher"


var question = ""
var solution = ""
var choices = []


func _ready() -> void:
	pass # Replace with function body.


func init(param):
	question = param["capital"]
	choices = param["choices"]
	print(question, ' ', choices)

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


func _on_MultipleChoice_button_up() -> void:
	get_node("Inline").visible = false
	get_node("MultipleChoice").visible = true


func _on_submit(text):
	switcher.check_answer(0, text)
