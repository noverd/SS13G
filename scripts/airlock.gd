extends AnimatableBody2D
# Airlock
var near = false # Is Player Near
var is_open: bool = false 
var playing: bool = false
@export var power: bool = true # is there power in the door?

@rpc("any_peer")
func sync(anim_name: String, open: bool):
	$Texture.play(anim_name)
	is_open = open
	playing = true

func _physics_process(delta):
	if power:
		if Input.is_action_just_pressed("intract"): # E
			if near and not playing:
				if is_open:
					$Texture.play("closing")
					playing = true
					is_open = false
					rpc("sync", "closing", is_open)
				else:
					$Texture.play("opening")
					playing = true
					is_open = true
					rpc("sync", "opening", is_open)

func _on_body_entred(body):
	if body.get("can_open_doors"): 
		near = true

func _on_body_exited(body):
	if body.get("can_open_doors"):
		near = false

func _on_played():
	playing = false
	$Collision.disabled = is_open
	$Texture/Shadow.occluder.closed = not is_open
