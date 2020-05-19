extends Node

onready var current_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() -1)

var levels: Array = []
var scenes: Array = ["res://Screens/Capital.tscn"]
#var start_scene: String = "res://Screens/StartScreen.tscn"
var start_scene: String = "res://Levels/World.tscn"
var rightwrong: String = "res://Screens/RightWrong.tscn"

var parameters = {}


func _ready():
	goto_scene(start_scene)


func start_game(choices):
	for i in range(len(choices)):
		if choices[i]:
			if i < len(scenes):
				levels.append(scenes[i])

	var level = choose_element(levels)

	parameters = { 
		"capital": "Sarajevo",
		"country": "Bosnia and Herzegovina",
		"choices": ["France", "Austria", "Romania", "Bosnia and Herzegovina"]
		}
	goto_scene(level)


func next_level():
	parameters = { 
		"capital": "Sarajevo",
		"country": "Bosnia and Herzegovina",
		"choices": ["France", "Austria", "Romania", "Bosnia and Herzegovina"]
		}
	var level = choose_element(levels)
	goto_scene(level)


func goto_scene(path):
	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	current_scene.free()

	var s = ResourceLoader.load(path)

	current_scene = s.instance()

	if len(parameters) > 0:
		current_scene.init(parameters)

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optional, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)


func choose_element(tab):
	return tab[randi() % tab.size()]


func check_answer(level, answer):
	if level == 0:
		parameters = [parameters["capital"], parameters["country"], answer]
		goto_scene(rightwrong)
