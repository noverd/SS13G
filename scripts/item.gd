extends Object
class_name Item
var item_icon: Texture2D
var item_id: String
var item_name: String 
var item_type: String
var item_params: Dictionary 
var item_data: Dictionary

func _init(id: String, name: String, icon: String, type: String, params: Dictionary, data: Dictionary = {}):
	item_icon = load(icon) ## Icon for item
	item_id = id ## Item id
	item_name = name ## Item name for localization
	item_type = type ## Slot for equip
	item_params = params ## Components for item
	item_data = data ## Data field for item data saving (ex. Inner Item List for duffel). Uses for presets

