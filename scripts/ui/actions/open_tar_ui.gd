extends Window
var items: Array = []
const item_ui = preload("res://scenes/ui/actions/ItemUI.tscn")

func _on_close_requested():
	queue_free()

func _ready():
	for item in items:
		var item_instance = item_ui.instantiate()
		item_instance.item = item
		$Panel/VBoxContainer.add_child(item_instance)
