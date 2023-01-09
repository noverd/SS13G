extends TextureButton

@export var Icon: Texture2D = null: set = set_icon
var slot: Texture

func set_icon(icon):
	if icon != null:
		Icon = icon
		$Icon.texture = Icon
		texture_normal = load("res://res/ui/slots/block.png")
	else:
		texture_normal = slot

func _ready():
	slot = texture_normal
		
