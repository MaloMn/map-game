extends GridContainer

signal click
var button = preload("res://Objects/ChoiceButton.tscn")
var background = {
	'green': Colors.GOOD,
	'red': Colors.BAD,
	'white': Colors.CELL_BG,
	'lightgreen': Colors.MOUSE_OVER
}

var _active_button_name = null
var _parent = null
var _solution = null
var _clicked = false
signal clicked

var timeout = 3.0  # in seconds


func _ready() -> void:
	# Removing examples buttons
	for i in range(4):
		get_node("fChoice" + str(i)).queue_free()
	
	for k in background.keys():
		var sbf = StyleBoxFlat.new()
		sbf.set_bg_color(background[k])
		sbf.corner_detail = 8
		background[k] = sbf


func init(parent, choices, solution):
	_solution = solution
	_parent = parent
	
	for i in range(len(choices)):
		# Create button and set its object name
		var b = button.instance()
		
		var name_choice = ""
		if choices[i] == "":
			name_choice = "Choice" + str(i)
		else:
			name_choice = choices[i]
		
		b.name = name_choice
		# Set label text of button
		b.init(name_choice)
		# Connecting the mouse inputs
		b.connect('mouse_entered', self, '_on_mouse_entered', [name_choice])
		b.connect('mouse_exited', self, '_on_mouse_exited', [name_choice])
		# Add it as child
		self.add_child(b)


func _input(event: InputEvent) -> void:
	# Handle click on button
	if Input.is_action_pressed("left_click") and _active_button_name and !_clicked:
		_clicked = true
		_check_answer(_active_button_name)


func _on_mouse_entered(button_name):
	if !_clicked:
		get_node(button_name).set('custom_styles/panel', background['lightgreen'])
		_active_button_name = button_name


func _on_mouse_exited(button_name):
	if !_clicked:
		get_node(button_name).set('custom_styles/panel', background['white'])
		_active_button_name = null


func _check_answer(answer):
	# Setting background green
	get_node(_solution).set('custom_styles/panel', background['green'])
	get_node(_solution).right()
	emit_signal("clicked")
	if _solution != answer:
		get_node(answer).set('custom_styles/panel', background['red'])
		get_node(answer).wrong()
	
	yield(get_tree().create_timer(timeout), "timeout")
	PageSwitcher.next_level()
