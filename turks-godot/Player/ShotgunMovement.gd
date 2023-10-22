extends KinematicBody2D

var speed = 150  # speed in pixels/sec
var velocity = Vector2.ZERO
enum MOVEMENT {LEFT, RIGHT, UP, DOWN}
var direction = MOVEMENT.RIGHT 

onready var animatedSprite = $AnimatedSprite

func set_idle_direction():
	if direction == MOVEMENT.RIGHT:
		animatedSprite.animation = "idle-right"
	if direction == MOVEMENT.LEFT:
		animatedSprite.animation = "idle-left"
	if direction == MOVEMENT.DOWN:
		animatedSprite.animation = "idle-down"
	if direction == MOVEMENT.UP:
		animatedSprite.animation = "idle-up"
		
func get_input():
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		animatedSprite.animation = "right"
		direction = MOVEMENT.RIGHT
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		animatedSprite.animation = "left"
		direction = MOVEMENT.LEFT
	elif Input.is_action_pressed("ui_down"):
		velocity.y += 1
		animatedSprite.animation = "down"
		direction = MOVEMENT.DOWN
	elif Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		animatedSprite.animation = "up"
		direction = MOVEMENT.UP
	else:
		set_idle_direction()
	

func _physics_process(_delta):
	get_input()
	velocity = velocity.normalized() * speed
	velocity = move_and_slide(velocity)
