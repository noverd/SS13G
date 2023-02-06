extends Node
var action_adders_list: Array = []
var items_list: Array = []
var actions_list: Array = []

## Registring item from .json file
func register_item_from_file(filename: String):
	var file = FileAccess.open(filename, FileAccess.READ)
	if file == null:
		Log.err("ItemManager LoadingJSON Error: Can't access .json file at path %s . File is empty" % filename)
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if parsed == null:
		Log.err("ItemManager LoadingJSON Error: Can`t parse json file %s" % filename)
		return
	
	if parsed.has("name")  && parsed.has("id") && parsed.has("icon") && parsed.has("type") && parsed.has("params"):
		parsed = replace_path(parsed, filename.get_base_dir() + "/")
		var data = {}
		if parsed.has("data"):
			data = parsed["data"]
		var actions = []
		if parsed.has("actions"):
			for act in parsed["actions"]:
				var action = ItemManager.get_action(act)
				if action != null:
					actions.append(action)
				else:
					Log.err("ItemManager LoadingJSON Error: ActionsParsing Error: unknow action '%s'" % action)
		items_list.append(
			Item.new(
				parsed["id"], parsed["name"], parsed["icon"], parsed["type"], parsed["params"], data, actions
				)
			)
		Log.l("ItemManager: Loaded .json file '%s' with item '%s'" % [filename, parsed["id"]])
	else:
		Log.err("ItemManager LoadingJSON Error: Invalid json file %s" % filename)

func get_item(id: String):
	for item in items_list:
		if item.item_id == id:
			return item
	return null

func get_action(id: String):
	for action in actions_list:
		if action.get("id") == id:
			return action
		return null

func replace_path(parsed, path):
	if parsed is Array:
		for key in range(parsed.size()):
			key -= 1
			if parsed[key] is String:
				parsed[key] = parsed[key].replace("./", path)
			if parsed[key] is Array:
				parsed[key] = replace_path(parsed[key], path)
			if parsed[key] is Dictionary:
				parsed[key] = replace_path(parsed[key], path)
	else:
		for key in parsed.keys():
			if parsed.get(key) is String:
				parsed[key] = parsed[key].replace("./", path)
			if parsed.get(key) is Array:
				parsed[key] = replace_path(parsed[key], path)
			if parsed.get(key) is Dictionary:
				parsed[key] = replace_path(parsed[key], path)
	return parsed

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

func _ready():
	for file in get_all_files("res://scripts/action_adders/", "gd"):
		action_adders_list.append(load(file))
		Log.l("ItemManager: Loaded .gd file '%s' with action_adder %s" % [file, action_adders_list[-1].id])
	for file in get_all_files("res://scripts/actions/", "gd"):
		actions_list.append(load(file))
		Log.l("ItemManager: Loaded .gd file '%s' with action %s" % [file, actions_list[-1].id])
	for file in get_all_files("res://"):
		register_item_from_file(file)
