extends Node
var items_list: Array = []

func load_item_from_json(filename: String):
	var file = FileAccess.open(filename, FileAccess.READ)
	if file == null:
		Log.err("ItemManager LoadingJSON Error: Can't access .json file at path %s . File is empty" % filename)
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if parsed == null:
		Log.err("ItemManager LoadingJSON Error: Can`t parse json file %s" % filename)
		return
	if parsed.has("name")  && parsed.has("id") && parsed.has("icon") && parsed.has("type") && parsed.has("params"):
		items_list.append(
			Item.new(
				parsed["id"], parsed["name"], parsed["icon"], parsed["type"], parsed["params"]
				)
			)
	else:
		Log.err("ItemManager LoadingJSON Error: Invalid json file %s" % filename)

func _ready():
	for file in get_all_files("res://"):
		load_item_from_json(file)

func get_all_files(path: String, file_ext = "json", files = []):
	var dir = DirAccess.open(path)

	if dir:
		dir.list_dir_begin()

		var file_name = dir.get_next()

		while file_name != "":
			if dir.current_is_dir():
				files = get_all_files(dir.get_current_dir().path_join(file_name), file_ext, files)
			else:
				if file_ext and file_name.get_extension() != file_ext:
					file_name = dir.get_next()
					continue

				files.append(dir.get_current_dir().path_join(file_name))

			file_name = dir.get_next()
	else:
		Log.err("ItemManager GettingAllFiles Error: An error occurred when trying to access %s." % path)

	return files



