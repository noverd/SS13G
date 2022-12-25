extends CharacterBody2D
@export var speed = 400 
@export var controlled = false
@export var can_open_doors = true # Can the creature open the door?
func _ready():
	$Camera2D.current = controlled
	
func get_input(): # Player control
	var vector = Input.get_vector("left", "right", "up", "down") 
	velocity = vector * speed
	
func _physics_process(delta):
	if controlled:
		get_input()
		move_and_slide()

