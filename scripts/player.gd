extends CharacterBody2D
@export var speed = 400 
var controlled: bool # controlled by u
@export var can_open_doors = true # Can the creature open the door?


func _ready():
	name = str(get_multiplayer_authority()) 
	controlled = is_multiplayer_authority()
	$Camera2D.current = controlled
	
func get_input():
	var vector = Input.get_vector("left", "right", "up", "down") 
	velocity = vector * speed
	
func _physics_process(delta):
	if controlled:
		get_input()
		move_and_slide()

