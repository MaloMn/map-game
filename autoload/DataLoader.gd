extends Node

var data_path: String = "res://data/data.csv"
var data = []

# Folder used
# Keep them here in case there are name changes in the futur
var folder_draw := "res://data/display/"
var folder_coll := "res://data/collision/"
var folder_pinpoint := "res://data/pinpoint/"
var folder_flag := "res://data/flag/"

# Variable containing external data
var polygons: Dictionary = {}
var pinpoints: Dictionary = {}
var flags: Dictionary = {}


func _ready() -> void:
	data = read_csv_file(data_path)

	polygons = collect_polygons()
	pinpoints = collect_pinpoints()
	flags = collect_flags()
	
	print("Loaded ", len(polygons), " polygons.")
	check_external_data()
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


func collect_flags():
	var column_polygon = column('Flag')
	var output = {}

	for i in range(len(column_polygon)):
		if column_polygon[i] == 'x':
			var country_short = data[i + 1][10]
			var flag = load(folder_flag + 'flag-' + country_short + '.png')
			output[country_short] = flag
	return output


func collect_pinpoints():
	var column_polygon = column('Pinpoint')
	var output = {}

	for i in range(len(column_polygon)):
		if column_polygon[i] == 'x':
			var country_short = data[i + 1][10]
			var city = get_json(folder_pinpoint + country_short + '.json')
			output[country_short] = city
	return output


func collect_polygons():
	var column_polygon = column('Polygon')
	var output = {}

	for i in range(len(column_polygon)):
		if column_polygon[i] == 'x':
			var country = []
			var country_short = data[i + 1][10]

			for folder in [folder_draw, folder_coll]:
				country.append(get_json(folder + country_short + '.json'))

			output[country_short] = country
	return output


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


func get_json(filename):
	var file = File.new()
	file.open(filename, file.READ)
	var text = file.get_as_text()
	file.close()
	# Parse JSON
	var result_json = JSON.parse(text)
	if result_json.error == OK:  
		# If parse OK
		return result_json.result
	else:  
		# If parse has errors
		print("Error: ", result_json.error)
		print("Error Line: ", result_json.error_line)
		print("Error String: ", result_json.error_string)
		return null


func check_external_data():
	# Checks that there isn't any null object in the external data.
	var error = false
	for p in polygons.values():
		if p[0] == null or p[1] == null:
			error = true
	for p in pinpoints.values():
		if p == null:
			error = true
	for p in flags:
		if p == null:
			error = true
			
	if error:
		print('Some data is  "null", something\'s not right!')
	else:
		print('No null object was found in imported external data.')


func get_line_of_short(shortname):
	var index = Array(column('short')).find(shortname)
	return data[index + 1]
