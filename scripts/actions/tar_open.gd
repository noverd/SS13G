extends Object

const id = "tar_open"
const name = "TarOpen"

static func can_action(item: Item, initiator):
	return true 
	
static func action(item: Item, initiator):
	## Open menu with item data
	return item ## Return changes

