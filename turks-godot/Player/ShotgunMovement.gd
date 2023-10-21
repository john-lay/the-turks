extends KinematicBody2D

var speed = 150  # speed in pixels/sec
var velocity = Vector2.ZERO
enum MOVEMENT {IDLE, LEFT, RIGHT, UP, DOWN}
signal movement(MOVEMENT)

func get_input():
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		emit_signal("movement", MOVEMENT.RIGHT)
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	elif Input.is_action_pressed("ui_down"):
		velocity.y += 1
	elif Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	else:
		emit_signal("movement", MOVEMENT.IDLE)
	# Make sure diagonal movement isn't faster
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
