extends TextureButton
@export var slot: String = "hand_l"
func _ready():
	texture_normal = load("res://res/ui/slots/" + slot + ".png")
