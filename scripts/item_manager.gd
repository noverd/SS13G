extends Node
var items_list: Array = []

func load_item_from_json(filename):
	var file = FileAccess.open(filename, FileAccess.READ)
	var parsed = JSON.parse_string(file.get_as_text())
	if parsed.get("name") && parsed.get("id") && parsed.get("icon") && parsed.get("type") && parsed.get("params"):
		items_list.append(
			Item.new(
				parsed["id"], parsed["name"], parsed["icon"], parsed["type"], parsed["params"]
				)
			)
	else:
		Log.err("ItemManager Error: Invalid json file %s" % filename)
	

