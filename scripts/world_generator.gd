extends Node2D

var folder := "res://countries_json/"
var data = null


func _ready() -> void:
	# Gathering the data
	for f in list_files_in_directory(folder, 0.1):
		print(str(folder + f))
		var file = File.new()
		file.open(str(folder + f), file.READ)
		var text = file.get_as_text()
		file.close()
		
		var result_json = JSON.parse(text)
		if result_json.error == OK:  # If parse OK
			data = result_json.result
#			print(typeof())
		else:  # If parse has errors
			print("Error: ", result_json.error)
			print("Error Line: ", result_json.error_line)
			print("Error String: ", result_json.error_string)

		var c = preload("res://Countries//Polygon.tscn").instance()
		c.init(data)
#		c.set_name(pays + '_' + str(i))
		add_child(c)


func list_files_in_directory(path, thresh):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and str(thresh) in file:
			files.append(file)
#		else:
#			print(file)

	dir.list_dir_end()
	print(files)
	return files
