extends Object
class_name Item
var item_icon: Texture2D
var item_id: String
var item_name: String 
var item_type: String
var item_params: Dictionary 
var item_data: Dictionary
var item_actions: Array

func _init(id: String, name: String, icon: String, type: String, params: Dictionary, data: Dictionary = {}, actions: Array = []):
	item_icon = load(icon) ## Icon for item
	item_id = id ## Item id
	item_name = name ## Item name for localization
	item_type = type ## Slot for equip
	item_params = params ## Components for item
	item_data = data ## Data field for item data saving (ex. Inner Item List for duffel). Uses for presets
	item_actions = actions ## Item actions
	for act_adder in ItemManager.action_adders_list:
		for act in act_adder.adder(self):
			var action = ItemManager.get_action(act)
			if action != null:
				item_actions.append(action)
			else:
				Log.err("ItemManager ItemInit Error: ActionAdders Error: unknow action '%s'" % action)

