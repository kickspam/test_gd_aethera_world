extends CharacterBody2D

const SPEED = 300.0
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var cam = $Camera2D



func _ready():
	position = Vector2(0,0)
	
	
func _input(event):
	if event.is_action_pressed("debug single chunk"):
		cam.zoom.x = 3.5
		cam.zoom.y = 3.5
	
	
func _physics_process(delta):
	var direction = Input.get_axis("move_left", "move_right")
	var facing_direction = Input.get_axis("move_up", "move_down")
	
	if direction != 0:
		velocity.x = direction * SPEED
		animated_sprite_2d.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if facing_direction != 0:
		velocity.y = facing_direction * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	# Check if ANY movement key is being pressed
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right") or Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down"):
		animated_sprite_2d.play("Walking")
	else:
		animated_sprite_2d.stop()
		animated_sprite_2d.play("Idle")

	move_and_slide()
