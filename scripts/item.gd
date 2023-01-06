extends Object
class_name Item
var item_icon: Texture2D
var item_id: String
var item_name: String 
var item_type: String
var item_params: Dictionary

func _init(id: String, name: String, icon: String, type: String, params: Dictionary):
	item_icon = load(icon)
	item_id = id
	item_name = name
	item_type = type
	item_params = params

