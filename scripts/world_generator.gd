extends Node2D

var folder_draw := "res://data/display/"
var folder_coll := "res://data/collision/"
var obj_area = preload("res://Objects/Area2D.tscn")
var data = null


func _ready() -> void:
	# Gathering the data
	var files = list_files_in_directory(folder_draw)

	for f in files:
		var data = []
		for folder in [folder_draw, folder_coll]:
			# Opening the file and reading it
			var file = File.new()
			file.open(folder + f, file.READ)
			var text = file.get_as_text()
			file.close()
			# Parse JSON
			var result_json = JSON.parse(text)
			if result_json.error == OK:  # If parse OK
				data.append(result_json.result)
			else:  # If parse has errors
				print("Error: ", result_json.error)
				print("Error Line: ", result_json.error_line)
				print("Error String: ", result_json.error_string)

		if len(data) == 2:
			var c = obj_area.instance()
			c.init(country(data[0]), country(data[1]))
			c.set_name(f.replace('.json', ''))
			add_child(c)
			print(len(data[0]), len(data[1]))


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
	print(files)
	return files


func country(poly):
	var country = []
	for p in poly:
		country.append(polygon(p))
	return country


func polygon(pts):
	var points = PoolVector2Array()
	for i in range(0, len(pts)):
		points.push_back(Vector2(pts[i][0], pts[i][1]))
	return points

