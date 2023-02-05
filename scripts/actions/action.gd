extends Object

const id = "use
"
const name = "UseAction"

static func action(item: Item):
	if item.data.get("used") == false: ## If the item has not been used
		item.data["used"] = true
	return item ## Return changes
