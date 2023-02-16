extends AnimatableBody2D
# Airlock
var near = false # Is Player Near
var is_open: bool = false 
var playing: bool = false
@export var power: bool = true # is there power in the door?

func _physics_process(delta):
	if power:
		if Input.is_action_just_pressed("intract"): # E
			if near and not playing:
				if not is_open:
					$Texture.play("openning")
					playing = true
					is_open = true
				else:
					$Texture.play("closing")
					playing = true
					is_open = false

func _on_body_entred(body):
	if body.get("can_open_doors"): 
		near = true

func _on_body_exited(body):
	if body.get("can_open_doors"):
		near = false

func _on_played():
	playing = false
	$Collision.disabled = is_open
	$Texture/Shadow.occluder.closed = is_open
