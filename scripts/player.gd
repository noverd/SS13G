extends CharacterBody2D
@export var speed = 400 
var controlled: bool # controlled by u
@export var can_open_doors = true # Can the creature open the door?
enum {FEMALE, MALE}
@export var gender: int = 1 # 0 - FEMALE, 1 - MALE
enum {UP, DOWN, RIGHT, LEFT}

func _ready():
	name = str(get_multiplayer_authority()) 
	controlled = is_multiplayer_authority()
	$Camera2D.current = controlled
	if gender == FEMALE:
		$Textures/Head.texture = preload("res://res/human/head_f.png")
		$Textures/Torso.texture = preload("res://res/human/torso_f.png")
	if gender == MALE:
		$Textures/Head.texture = preload("res://res/human/head_m.png")
		$Textures/Torso.texture = preload("res://res/human/torso_m.png")
	rpc("sync", global_position)
	
func get_input():
	var vector: Vector2 = Input.get_vector("left", "right", "up", "down") 
	velocity = vector * speed
	if vector != Vector2(0.0, 0.0):
		if vector == Vector2(0.0, -1.0):
			rotate_textures(DOWN)
		if vector == Vector2(0.0, 1.0):
			rotate_textures(UP)
		if vector == Vector2(-1.0, 0.0):
			rotate_textures(LEFT)
		if vector == Vector2(1.0, 0.0):
			rotate_textures(RIGHT)
		rpc("sync", global_position)
	
func _physics_process(delta):
	if controlled:
		get_input()
		move_and_slide()
		
@rpc(unreliable)
func sync(pos):
	global_position = pos
	
func rotate_textures(rot): # Call rotate local and call rotate remote
	for tex in $Textures.get_children():
		tex.frame = rot
	rpc("rotate", rot)
	
@rpc(unreliable)
func rotate(rot):
	for tex in $Textures.get_children():
		tex.frame = rot
