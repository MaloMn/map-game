extends Node

# Get current scene (EmptyScene.tscn)
onready var root = get_tree().get_root()
onready var current_scene = root.get_child(root.get_child_count() -1)


var pages: Array = ["res://Pages/CountryCapital.tscn",
					"res://Pages/CountryLocation.tscn",
					"res://Pages/CountryFlag.tscn",
					"res://Pages/CapitalLocation.tscn"]
var possibilities = [[0, 2], [0, 7], [0, 5], [2, 8]]

var start_scene = "res://Screens/StartScreen.tscn"


func _ready():
#	pass
#	goto_scene(start_scene, null)
	goto_scene('res://Pages/CountryCapital.tscn', 'brazil')


func start_game(choices):
	next_level()
#	goto_scene('res://Pages/CountryLocation.tscn', null)


func next_level():
	# Pick a line from data (not the header)
	var pages_data = []
	var pages_possible = []
	
	while len(pages_possible) == 0:
		# Choosing a line from data array
		var line = DataLoader.data[random_int(1, len(DataLoader.data) - 1)]
		print("Following line was chosen: ", line)

		pages_possible = []

		for i in range(len(pages)):
			var a = possibilities[i][0]
			var b = possibilities[i][1]
			if line[a] and line[b]:
				# If we have some data corresponding to the page
				pages_possible.append(pages[i])
		
		if len(pages_possible) > 0:
			var index = random_int(0, len(pages_possible) - 1)
			goto_scene(pages_possible[index], line[9])
			print('Following level was chosen: ', pages_possible[index])


func goto_scene(path, param):
	call_deferred("_deferred_goto_scene", path, param)


func _deferred_goto_scene(path, param):
	# It is now safe to remove the current scene
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instance()

	if param:
		current_scene.init(param)

	# Add it to the active scene, as child of root.
	root.add_child(current_scene)
	# Optional, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)


func random_int(a: int, b: int):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var my_random_number = rng.randi_range(a, b)
	return my_random_number
