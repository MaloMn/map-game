extends Node

var folder_draw: String = "res://data/display/"
var folder_coll: String = "res://data/collision/"
var data_path: String = "res://data/data.csv"
var polygons: Dictionary = {}
var data = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	polygons = collect_polygons(folder_draw, folder_coll)
	print('Safely loaded ', len(polygons.keys()), ' countries with their polygons')
	data = read_csv_file(data_path)
#	data.shuffle()


func read_csv_file(path):
	var tab = []
	var file = File.new()
	file.open(path, file.READ)
	while !file.eof_reached():
		var line = file.get_csv_line()
		# Removing the index column
		line.remove(0)
		if len(line) > 0:
			tab.append(line)
	
	file.close()
	return tab


func column(title):
	var index = Array(data[0]).find(title)
	var column = []
	for line in data:
		# Adding the required value to the array
		column.append(line[index])
	column.pop_front()
	return column


func collect_polygons(f_draw, f_coll):
	var files = list_files_in_directory(f_draw)
	var data: Dictionary = {}
	for f in files:
		var country = []
		for folder in [f_draw, f_coll]:
			# Opening the file and reading it
			var file = File.new()
			file.open(folder + f, file.READ)
			var text = file.get_as_text()
			file.close()
			# Parse JSON
			var result_json = JSON.parse(text)
			if result_json.error == OK:  # If parse OK
				country.append(result_json.result)
			else:  # If parse has errors
				print("Error: ", result_json.error)
				print("Error Line: ", result_json.error_line)
				print("Error String: ", result_json.error_string)
		
		# data will be ordered the following way:
		# data['country_name'] = [display_polygon, collision_polygon]
		data[f.replace('.json', '')] = country
		
	return data


func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()
	return files


func get_random_names(column_name, value, nb):
	var all_names = self.column(column_name)
	all_names.erase(value)
	
	var names_choices = [value]
	for i in range(nb - 1):
		var selection = all_names[PageSwitcher.random_int(0, len(all_names) - 1)]
		names_choices.append(selection)
		all_names.erase(selection)

	names_choices.shuffle()
	return names_choices
