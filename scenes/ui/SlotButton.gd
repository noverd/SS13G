extends TextureButton

@export var Icon: Texture
var slot: Texture

func _ready():
	slot = texture_normal
		
func _physics_process(delta):
	if Icon != null:
		$Icon.texture = Icon
		texture_normal = load("res://res/ui/slots/block.png")
	else:
		texture_normal = slot
