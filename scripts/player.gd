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
	return get_multiplayer_authority() == multiplayer.get_unique_id()
	
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
	set_multiplayer_authority(name.to_int())
	controlled = is_local_authority()
	$CanvasLayer/PlayerUI.visible = controlled
	$Camera2D.enabled = controlled
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

func _ready():
	var item = ItemManager.get_item('ancient_backpack')
	item.item_data["items"] = [item]
	print(item.item_data)
	ItemManager.get_action("tar_open").action(item, self)

@rpc
func sync_pos(pos):
	global_position = pos

@rpc
func sync_rotate(rot):
	rotate = rot

func get_input():
	var vector: Vector2 = Input.get_vector("left", "right", "up", "down") 
	if vector != Vector2(0.0, 0.0):
		if vector == Vector2(0.0, -1.0):
			rotate = DOWN
		if vector == Vector2(0.0, 1.0):
			rotate = UP
		if vector == Vector2(-1.0, 0.0):
			rotate = LEFT
		if vector == Vector2(1.0, 0.0):
			rotate = RIGHT
	rpc("sync_rotate", rotate)
	velocity = vector * speed

func _physics_process(delta):
	if controlled:
		get_input()
		move_and_slide()
		rpc("sync_pos", global_position)
	for tex in $Textures.get_children():
		tex.frame = rotate
	cloth("uniform", uniform)
	cloth("back", back)
	cloth("boots", boots)
	cloth("head", head)
	cloth("belt", belt)

func _input(event):
	if event is InputEventMouseButton and controlled:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var end = get_viewport_rect().end
			if end.x / 2 > event.position.x and end.y / 2 > event.position.y:
				rotate = DOWN
			if end.x / 2 < event.position.x and end.y / 2 > event.position.y:
				rotate = RIGHT
			if end.x / 2 > event.position.x and end.y / 2 < event.position.y:
				rotate = UP
			if end.x / 2 < event.position.x and end.y / 2 < event.position.y:
				rotate = LEFT
		rpc("sync_rotate", rotate)
		
