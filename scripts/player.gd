extends CharacterBody2D
@export var speed = 400 
var controlled: bool # controlled by u
@export var rotate: int = 0
@export var can_open_doors = true # Can the creature open the door?
enum {FEMALE, MALE}
@export var gender: int = 0 # 0 - FEMALE, 1 - MALE
enum {UP, DOWN, RIGHT, LEFT}

@export var uniform = "ancient_uniform" # Cloth ID
@export var back = "ancient_backpack"
@export var boots = "work_boots"
@export var head = "blue_cap"
@export var belt = "utility_belt"

func is_local_authority():
	return $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id()
	
func cloth(clothing_type: String, item_id):
	var item = ItemManager.get_item(item_id)
	if item == null:
		Log.err("Player Clothing: UnknowItemError: unknow item '%s'" % item_id)
		$CanvasLayer/PlayerUI/HBox.get_node(clothing_type.capitalize()).Icon = null
		$Textures.get_node(clothing_type.capitalize()).texture = null
		return
	$CanvasLayer/PlayerUI/HBox.get_node(clothing_type.capitalize()).Icon = item.item_icon
	$Textures.get_node(clothing_type.capitalize()).texture = load(item.item_params["texture"].get("equipped"))
	
func _enter_tree():
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
	cloth("uniform", uniform)
	cloth("back", back)
	cloth("boots", boots)
	cloth("head", head)
	cloth("belt", belt)
	
