extends KinematicBody2D

var speed = 175  # speed in pixels/sec
var velocity = Vector2.ZERO
enum MOVEMENT {LEFT, RIGHT, UP, DOWN}
var direction = MOVEMENT.RIGHT

export(PackedScene) var PROJECTILE: PackedScene = preload("res://Battle/ProjectileSprite.tscn")

onready var animatedSprite = $AnimatedSprite

# the below line is equivalent to
#onready var projectile = $ProjectileSprite
# the below 3 lines
#var projectile
#func _ready():
#	projectile = get_node("ProjectileSprite")

func set_idle_direction():
	if direction == MOVEMENT.RIGHT:
		animatedSprite.animation = "idle-right"
	if direction == MOVEMENT.LEFT:
		animatedSprite.animation = "idle-left"
	if direction == MOVEMENT.DOWN:
		animatedSprite.animation = "idle-down"
	if direction == MOVEMENT.UP:
		animatedSprite.animation = "idle-up"

func fire_projectile():
	if PROJECTILE:
		var projectile = PROJECTILE.instance()
		get_tree().current_scene.add_child(projectile)
		projectile.set("direction", Vector2.RIGHT)

func get_input():
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		animatedSprite.animation = "move-right"
		direction = MOVEMENT.RIGHT
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		animatedSprite.animation = "move-left"
		direction = MOVEMENT.LEFT
	elif Input.is_action_pressed("ui_down"):
		velocity.y += 1
		animatedSprite.animation = "move-down"
		direction = MOVEMENT.DOWN
	elif Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		animatedSprite.animation = "move-up"
		direction = MOVEMENT.UP
	elif Input.is_action_just_pressed("ui_accept"):
		fire_projectile()
	else:
		set_idle_direction()
	

func _physics_process(_delta):
	get_input()
	velocity = velocity.normalized() * speed
	velocity = move_and_slide(velocity)
