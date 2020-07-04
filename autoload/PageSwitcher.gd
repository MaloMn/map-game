extends Node

# Get current scene (EmptyScene.tscn)
onready var root = get_tree().get_root()
onready var current_scene = root.get_child(root.get_child_count() -1)


var pages: Array = ["res://Pages/CountryCapital.tscn"] 
#					"res://Pages/CountryLocation.tscn",
#					"res://Pages/CapitalLocation.tscn",
#					"res://Pages/CountryFlag.tscn"]
var possibilities = [[0, 2]]#, [0, 7], [2, 8], [0, 5]]

var start_scene = "res://Screens/StartScreen.tscn"


func _ready():
	goto_scene(start_scene, null)


func start_game(choices):
	next_level()


func next_level():
	# Pick a line from data (not the header)
	var pages_data = []
	var pages_binary = []
	
	while len(pages_binary) == 0 or !pages_binary.has(1):
		var line = DataLoader.data[random_int(1, len(DataLoader.data) - 1)]
		print("Following line was chosen: ", line)
		
		pages_data = []
		pages_binary = []
		
		# For each page, check if we have the data
		for i in range(len(pages)):
			var a = possibilities[i][0]
			var b = possibilities[i][1]
			if not line[a] or not line[b]:
				pages_binary.append(0)
			else:
				pages_data.append([line[a], line[b]])
				pages_binary.append(1)
	
	var index = random_scene_index(pages_binary)
	goto_scene(pages[index], pages_data[index])


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


func random_scene_index(binary):
	if (len(binary) <= 0) or !binary.has(1):
		print('Error, got this binary array: ', binary)
	
	var array = []
	for i in range(len(binary)):
		if binary[i] == 1:
			array.append(i)
	
	return array[random_int(0, len(array) - 1)]


func random_int(a: int, b: int):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var my_random_number = rng.randi_range(a, b)
	return my_random_number
