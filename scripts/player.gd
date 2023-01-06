extends CharacterBody2D
@export var speed = 400 
var controlled: bool # controlled by u
@export var rotate: int = 0
@export var can_open_doors = true # Can the creature open the door?
enum {FEMALE, MALE}
@export var gender: int = 0 # 0 - FEMALE, 1 - MALE
enum {UP, DOWN, RIGHT, LEFT}

var uniform = "ancient" # Cloth ID
var back = "ancient_backpack"
var boots = "workboots"
var head = "bluecap"
var belt = "utility"

func is_local_authority():
	return $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id()
	
func cloth(clothing_type: String, clothing: String):
	var path =  "res://res/clothes/" + clothing_type + "/" + clothing + "/"
	$CanvasLayer/PlayerUI/HBox.get_node(clothing_type.capitalize()).Icon = load(path + "icon.png")
	$Textures.get_node(clothing_type.capitalize()).texture = load(path + "equipped.png")
	
func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	controlled = is_local_authority()
	$CanvasLayer/PlayerUI.visible = controlled
	$Camera2D.current = controlled
	if gender == FEMALE:
		$Textures/BodyHead.texture = preload("res://res/human/head_f.png")
		$Textures/Torso.texture = preload("res://res/human/torso_f.png")
	if gender == MALE:
		$Textures/BodyHead.texture = preload("res://res/human/head_m.png")
		$Textures/Torso.texture = preload("res://res/human/torso_m.png")
	cloth("uniform", uniform)
	cloth("back", back)
	cloth("boots", boots)
	cloth("head", head)
	cloth("belt", belt)

func get_input():
	var vector: Vector2 = Input.get_vector("left", "right", "up", "down") 
	velocity = vector * speed
	if vector != Vector2(0.0, 0.0):
		if vector == Vector2(0.0, -1.0):
			rotate = DOWN
		if vector == Vector2(0.0, 1.0):
			rotate = UP
		if vector == Vector2(-1.0, 0.0):
			rotate = LEFT
		if vector == Vector2(1.0, 0.0):
			rotate = RIGHT
	
func _physics_process(delta):
	if controlled:
		get_input()
		move_and_slide()
	for tex in $Textures.get_children():
		tex.frame = rotate
	
