extends Object

const id = "tar_adder"

static func adder(item: Item):
	var actions = []
	if item.item_params.has("tar"):
		actions.append("tar_open")
	return actions # Returns Action array
	
