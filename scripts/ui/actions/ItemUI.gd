extends Control
class_name ItemUI
var item: Item

func _ready():
	$HBox/Label.text = "%s %s" % [item.item_name, "simple_mass"]
	$HBox/TextureRect.texture = item.item_icon
