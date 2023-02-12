extends Object

const id = "tar_open"
const name = "TarOpen"

static func can_action(item: Item, initiator):
	return true 
	
static func action(item: Item, initiator):
	var ui = preload("res://scenes/ui/actions/OpenTarUI.tscn").instantiate()
	for it in item.item_data.get("items", []):
		ui.items.append(it)
	initiator.get_node("CanvasLayer").add_child(ui)
	return item ## Return changes

